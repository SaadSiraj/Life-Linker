import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/shared/app_text.dart';
import 'package:lifelinker/core/utils/size_utils.dart';

enum ForgotPasswordStep { email, otp, newPassword, success }

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(4, (_) => FocusNode());

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  ForgotPasswordStep _currentStep = ForgotPasswordStep.email;
  int _resendTimer = 0;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
    _animController.forward();
  }

  void _transitionToStep(ForgotPasswordStep step) {
    _animController.reverse().then((_) {
      setState(() => _currentStep = step);
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your email address');
      return;
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text.trim())) {
      _showErrorSnackBar('Please enter a valid email address');
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _resendTimer = 60;
      });
      _transitionToStep(ForgotPasswordStep.otp);
      _startResendTimer();
    }
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 4) {
      _showErrorSnackBar('Please enter the 4-digit OTP');
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      _transitionToStep(ForgotPasswordStep.newPassword);
    }
  }

  Future<void> _handleResetPassword() async {
    if (_newPasswordController.text.isEmpty) {
      _showErrorSnackBar('Please enter a new password');
      return;
    }
    if (_newPasswordController.text.length < 6) {
      _showErrorSnackBar('Password must be at least 6 characters');
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Passwords do not match');
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      _transitionToStep(ForgotPasswordStep.success);
    }
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() => _resendTimer--);
        _startResendTimer();
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.alert, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(message, size: 14, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.textDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(16.h),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep == ForgotPasswordStep.success
            ? null
            : IconButton(
                icon: Container(
                  width: 38.h,
                  height: 38.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16.h,
                    color: AppColors.textDark,
                  ),
                ),
                onPressed: () {
                  if (_currentStep == ForgotPasswordStep.email) {
                    Navigator.pop(context);
                  } else if (_currentStep == ForgotPasswordStep.otp) {
                    _transitionToStep(ForgotPasswordStep.email);
                  } else if (_currentStep == ForgotPasswordStep.newPassword) {
                    _transitionToStep(ForgotPasswordStep.otp);
                  }
                },
              ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.h),
                child: _buildCurrentStep(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case ForgotPasswordStep.email:
        return _buildEmailStep();
      case ForgotPasswordStep.otp:
        return _buildOtpStep();
      case ForgotPasswordStep.newPassword:
        return _buildNewPasswordStep();
      case ForgotPasswordStep.success:
        return _buildSuccessStep();
    }
  }

  // ─── STEP 1: Email ────────────────────────────────────────────────────────

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap.v(16),

        // Icon
        Container(
          width: 64.h,
          height: 64.h,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.lock_reset_rounded,
            size: 32.h,
            color: AppColors.primary,
          ),
        ),

        Gap.v(20),

        AppText(
          'Forgot Password?',
          size: 26,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),

        Gap.v(8),

        AppText(
          'No worries! Enter your registered email\nand we\'ll send you a reset code.',
          size: 14,
          color: AppColors.iconGrey,
          fontWeight: FontWeight.w400,
        ),

        Gap.v(36),

        _buildTextField(
          controller: _emailController,
          hint: 'Email address',
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),

        Gap.v(32),

        _buildPrimaryButton(
          label: 'Send Reset Code',
          onPressed: _handleSendOtp,
          isLoading: _isLoading,
        ),

        Gap.v(24),
      ],
    );
  }

  // ─── STEP 2: OTP ──────────────────────────────────────────────────────────

  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap.v(16),

        Container(
          width: 64.h,
          height: 64.h,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.verified_outlined,
            size: 32.h,
            color: AppColors.primary,
          ),
        ),

        Gap.v(20),

        AppText(
          'Check Your Email',
          size: 26,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),

        Gap.v(8),

        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14.fSize,
              fontFamily: 'Poppins',
              color: AppColors.iconGrey,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'We sent a 4-digit code to\n'),
              TextSpan(
                text: _emailController.text.trim(),
                style: TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        Gap.v(36),

        // OTP boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (index) => _buildOtpBox(index)),
        ),

        Gap.v(28),

        // Resend
        Center(
          child: _resendTimer > 0
              ? RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13.fSize,
                      fontFamily: 'Poppins',
                      color: AppColors.iconGrey,
                    ),
                    children: [
                      const TextSpan(text: 'Resend code in '),
                      TextSpan(
                        text: '${_resendTimer}s',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() => _resendTimer = 60);
                    _startResendTimer();
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13.fSize,
                        fontFamily: 'Poppins',
                        color: AppColors.iconGrey,
                      ),
                      children: [
                        const TextSpan(text: "Didn't receive it? "),
                        TextSpan(
                          text: 'Resend',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),

        Gap.v(32),

        _buildPrimaryButton(
          label: 'Verify Code',
          onPressed: _handleVerifyOtp,
          isLoading: _isLoading,
        ),

        Gap.v(24),
      ],
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 64.h,
      height: 64.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: 22.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          isDense: true,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _otpFocusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _otpFocusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  // ─── STEP 3: New Password ─────────────────────────────────────────────────

  Widget _buildNewPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap.v(16),

        Container(
          width: 64.h,
          height: 64.h,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.lock_outline_rounded,
            size: 32.h,
            color: AppColors.primary,
          ),
        ),

        Gap.v(20),

        AppText(
          'New Password',
          size: 26,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),

        Gap.v(8),

        AppText(
          'Create a strong password to keep\nyour account secure.',
          size: 14,
          color: AppColors.iconGrey,
          fontWeight: FontWeight.w400,
        ),

        Gap.v(36),

        _buildTextField(
          controller: _newPasswordController,
          hint: 'New password',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscureNewPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNewPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.iconGrey,
              size: 20.h,
            ),
            onPressed: () =>
                setState(() => _obscureNewPassword = !_obscureNewPassword),
          ),
        ),

        Gap.v(16),

        _buildTextField(
          controller: _confirmPasswordController,
          hint: 'Confirm new password',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscureConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.iconGrey,
              size: 20.h,
            ),
            onPressed: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword),
          ),
        ),

        Gap.v(32),

        _buildPrimaryButton(
          label: 'Reset Password',
          onPressed: _handleResetPassword,
          isLoading: _isLoading,
        ),

        Gap.v(24),
      ],
    );
  }

  // ─── STEP 4: Success ──────────────────────────────────────────────────────

  Widget _buildSuccessStep() {
    return Column(
      children: [
        Gap.v(60),

        // Animated success icon
        Container(
          width: 120.h,
          height: 120.h,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: 64.h,
            color: AppColors.primary,
          ),
        ),

        Gap.v(28),

        AppText(
          'All Done!',
          size: 28,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),

        Gap.v(12),

        AppText(
          'Your password has been reset\nsuccessfully.',
          size: 14,
          color: AppColors.iconGrey,
          fontWeight: FontWeight.w400,
          align: TextAlign.center,
        ),

        Gap.v(48),

        _buildPrimaryButton(
          label: 'Back to Login',
          onPressed: () => Navigator.pop(context),
          isLoading: false,
        ),

        Gap.v(24),
      ],
    );
  }

  // ─── Shared Widgets ───────────────────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 14.fSize,
          fontFamily: 'Poppins',
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14.fSize,
            fontFamily: 'Poppins',
            color: AppColors.iconGrey,
          ),
          prefixIcon: Icon(prefixIcon, color: AppColors.iconGrey, size: 20.h),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.v),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
    required bool isLoading,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52.v,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : AppText(
                label,
                size: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
      ),
    );
  }
}