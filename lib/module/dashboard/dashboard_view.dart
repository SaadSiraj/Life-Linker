import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/constants/app_images.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/shared/app_text.dart';
import 'package:lifelinker/module/health_monitoring/health_data.dart';

// ─── Data Model ────────────────────────────────────────────────────────────

class PatientDashboardData {
  final String patientName;
  final bool isSafe;
  final String locationLabel;
  final String locationSub;
  final String medicationLabel;
  final String medicationSub;
  final int knownPeopleCount;
  final String knownPeopleSub;
  final String healthLabel;
  final String healthSub;

  const PatientDashboardData({
    required this.patientName,
    required this.isSafe,
    required this.locationLabel,
    required this.locationSub,
    required this.medicationLabel,
    required this.medicationSub,
    required this.knownPeopleCount,
    required this.knownPeopleSub,
    required this.healthLabel,
    required this.healthSub,
  });
}

// ─── Mock API Service ──────────────────────────────────────────────────────
// Replace this with your actual API calls.

class DashboardApiService {
  static Future<PatientDashboardData> fetchDashboard() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 900));

    // TODO: Replace with real HTTP call, e.g.:
    // final res = await http.get(Uri.parse('$baseUrl/dashboard'));
    // final json = jsonDecode(res.body);
    // return PatientDashboardData.fromJson(json);

    return const PatientDashboardData(
      patientName: 'John Adeola',
      isSafe: true,
      locationLabel: 'Home – Living Room',
      locationSub: 'Last seen 2 min ago',
      medicationLabel: 'Donepezil · 10mg',
      medicationSub: 'Next dose at 8:00 PM',
      knownPeopleCount: 12,
      knownPeopleSub: 'Family & caregivers',
      healthLabel: 'Heart rate 72 bpm',
      healthSub: 'All vitals normal',
    );
  }
}

// ─── Dashboard View ────────────────────────────────────────────────────────

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late Future<PatientDashboardData> _dataFuture;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _dataFuture = DashboardApiService.fetchDashboard();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {
      _dataFuture = DashboardApiService.fetchDashboard();
    });
  }

  // ─── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: FutureBuilder<PatientDashboardData>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingView();
          }
          if (snapshot.hasError) {
            return _ErrorView(onRetry: _refresh);
          }
          final data = snapshot.requireData;
          return Column(
            children: [
              Expanded(child: _buildBody(data)),
              _buildSOSBar(),
            ],
          );
        },
      ),
    );
  }

  // ─── Body ───────────────────────────────────────────────────────────────

  Widget _buildBody(PatientDashboardData data) {
    return RefreshIndicator(
      onRefresh: () async => _refresh(),
      color: AppColors.primary,
      child: CustomScrollView(
        // shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          
          SliverToBoxAdapter(child: _buildHeader(data)),
          SliverToBoxAdapter(child: Gap.v(20)),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.h, 0, 16.h, 24.v),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate([
                _DashCard(
                  icon: Icons.location_on_rounded,
                  iconColor: const Color(0xFF3B82F6),
                  iconBg: const Color(0xFFEFF6FF),
                  title: 'Location',
                  value: data.locationLabel,
                  subtitle: data.locationSub,
                  onTap: () => (){},
                ),
                _DashCard(
                  icon: Icons.medication_rounded,
                  iconColor: const Color(0xFF10B981),
                  iconBg: const Color(0xFFECFDF5),
                  title: 'Medication',
                  value: data.medicationLabel,
                  subtitle: data.medicationSub,
                  onTap: () => (){},
                ),
                _DashCard(
                  icon: Icons.people_alt_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  iconBg: const Color(0xFFFFFBEB),
                  title: 'Known People',
                  value: '${data.knownPeopleCount} contacts',
                  subtitle: data.knownPeopleSub,
                  onTap: () => (){}
                ),
                _DashCard(
                  icon: Icons.favorite_rounded,
                  iconColor: const Color(0xFFEF4444),
                  iconBg: const Color(0xFFFEF2F2),
                  title: 'Health',
                  value: data.healthLabel,
                  subtitle: data.healthSub,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HealthDataView()),
                  ),
                ),
              ]),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.h,
                mainAxisSpacing: 10.v,
                childAspectRatio: 1.0,
              ),
            ),
          ),
            SliverToBoxAdapter(child:Image.asset(AppImages.building)),
        ],
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────────

  Widget _buildHeader(PatientDashboardData data) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color:AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.h, 16.v, 20.h, 24.v),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Logo + refresh
              // Row(
              //   children: [
              //     // Container(
              //     //   width: 80.h,
              //     //   height: 80.h,
              //     //   decoration: BoxDecoration(
              //     //     color: AppColors.cardWhite,
              //     //     shape: BoxShape.circle,
              //     //   ),
              //     //   child: Padding(
              //     //     padding: const EdgeInsets.all(8.0),
              //     //     child: Image.asset(
              //     //       AppImages.logo,
                    
              //     //       fit: BoxFit.cover,
              //     //     ),
              //     //   ),
              //     // ),
              //     SizedBox(width: 10.h),
              //     AppText(
              //       'LifeLinker',
              //       size: 33,
              //       color: AppColors.cardWhite,
              //       fontWeight: FontWeight.w700,
              //       letterSpacing: 0.3,
              //     ),
              //     const Spacer(),
              //     GestureDetector(
              //       onTap: _refresh,
              //       child: Icon(Icons.refresh_rounded,
              //           color: AppColors.cardWhite, size: 22.h),
              //     ),
              //   ],
              // ),




              // SizedBox(height: 20.v),

              // Patient row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 28.h,
                    backgroundColor: AppColors.cardWhite.withOpacity(0.12),
                    child: Icon(Icons.person_rounded,
                        color: AppColors.cardWhite, size: 30.h),
                  ),

                  SizedBox(width: 14.h),

                  // Name & status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          data.patientName,
                          size: 20,
                          color: AppColors.cardWhite,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(height: 4.v),
                        Container(
                          width: 80.h,
                          height: 20.h,
                          // padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 4.v),
                          decoration: BoxDecoration(
                            color: data.isSafe
                                ? const Color(0xFFECFDF5)
                                : const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 8.h,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: data.isSafe
                                        ? const Color(0xFF10B981)
                                        : AppColors.alert,
                                  ),
                                ),
                                SizedBox(width: 4.h),
                                AppText(
                                  data.isSafe ? 'Safe' : 'Danger',
                                  size: 13,
                                  color: data.isSafe
                                      ? const Color(0xFF10B981)
                                      : AppColors.alert,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status badge
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.h, vertical: 6.v),
                    decoration: BoxDecoration(
                      color: data.isSafe
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AppText(
                      data.isSafe ? '✓ Monitored' : '⚠ Alert',
                      size: 12,
                      color: data.isSafe
                          ? const Color(0xFF059669)
                          : AppColors.alert,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SOS Bar ────────────────────────────────────────────────────────────

  Widget _buildSOSBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10.h, 5.v, 6.h, 14.v),
      child: Row(
        children: [
          // SOS Button
          Expanded(
            flex: 3,
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: GestureDetector(
                onTap: _onSOSTap,
                child: Container(
                  height: 56.v,
                  decoration: BoxDecoration(
                    color: AppColors.alert,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.alert.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_rounded,
                          color: Colors.white, size: 22.h),
                      SizedBox(width: 8.h),
                      AppText(
                        'SOS ALERT',
                        size: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 12.h),

          // Call Button
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: _onCallTap,
              child: Container(
                height: 56.v,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone_rounded,
                        color: AppColors.primary, size: 18.h),
                    SizedBox(width: 4.h),
                    AppText('Call',
                        size: 14,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Actions ────────────────────────────────────────────────────────────

  void _navigate(String route) {
    Navigator.pushNamed(context, route);
  }

  void _onSOSTap() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: AppColors.alert, size: 24.h),
            SizedBox(width: 8.h),
            AppText('SOS Alert',
                size: 16,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700),
          ],
        ),
        content: AppText(
          'Are you sure you want to send an SOS alert? Emergency contacts will be notified immediately.',
          size: 13,
          color: AppColors.iconGrey,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText('Cancel',
                size: 13,
                color: AppColors.iconGrey,
                fontWeight: FontWeight.w500),
          ),
          ElevatedButton(
            onPressed: () => (){},
            // onPressed: () {
            //   Navigator.pop(context);
            //   _navigate('/emergency');
            // },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.alert,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: AppText('Send Alert',
                size: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _onCallTap() {
    // TODO: launch phone dialer
  }
}

// ─── Dashboard Card ─────────────────────────────────────────────────────────

class _DashCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback onTap;

  const _DashCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon badge
            Container(
              width: 42.h,
              height: 42.h,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22.h),
            ),

            const Spacer(),

            // Title
            AppText(
              title,
              size: 11,
              color: AppColors.iconGrey,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),

            SizedBox(height: 3.v),

            // Value
            AppText(
              value,
              size: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
              maxLines: 2,
            ),

            SizedBox(height: 2.v),

            // Subtitle
            AppText(
              subtitle,
              size: 11,
              color: AppColors.iconGrey,
              fontWeight: FontWeight.w400,
              maxLines: 1,
            ),

            SizedBox(height: 6.v),

            // Arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 12.h, color: AppColors.iconGrey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Loading View ───────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
          SizedBox(height: 16.v),
          AppText(
            'Loading patient data…',
            size: 13,
            color: AppColors.iconGrey,
          ),
        ],
      ),
    );
  }
}

// ─── Error View ─────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 52.h, color: AppColors.iconGrey),
            SizedBox(height: 16.v),
            AppText(
              'Could not load dashboard',
              size: 16,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 8.v),
            AppText(
              'Check your connection and try again.',
              size: 13,
              color: AppColors.iconGrey,
              align: TextAlign.center,
            ),
            SizedBox(height: 24.v),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                padding:
                    EdgeInsets.symmetric(horizontal: 32.h, vertical: 12.v),
              ),
              child: AppText('Retry',
                  size: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}