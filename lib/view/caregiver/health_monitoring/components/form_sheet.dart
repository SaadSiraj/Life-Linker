import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/model/health_record.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/provider/health.dart';
import 'package:provider/provider.dart';

class RecordFormSheet extends StatefulWidget {
  final UserModel patient;
  const RecordFormSheet({super.key, required this.patient});

  @override
  State<RecordFormSheet> createState() => _RecordFormSheetState();
}

class _RecordFormSheetState extends State<RecordFormSheet> {
  final _hrCtrl = TextEditingController();
  final _sysCtrl = TextEditingController();
  final _diaCtrl = TextEditingController();
  final _tempCtrl = TextEditingController();
  final _o2Ctrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _hrCtrl.dispose();
    _sysCtrl.dispose();
    _diaCtrl.dispose();
    _tempCtrl.dispose();
    _o2Ctrl.dispose();
    _weightCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.widthMultiplier * 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: SizeConfig.widthMultiplier * 10,
                    height: SizeConfig.heightMultiplier * 0.5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                AppText(
                  'Add Health Reading',
                  size: 18,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                _buildRow(
                  'Heart Rate (bpm)',
                  _hrCtrl,
                  'e.g. 72',
                  Icons.favorite_rounded,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        'Systolic (mmHg)',
                        _sysCtrl,
                        'e.g. 120',
                        Icons.monitor_heart_outlined,
                      ),
                    ),
                    SizedBox(width: SizeConfig.widthMultiplier * 3),
                    Expanded(
                      child: _buildField(
                        'Diastolic',
                        _diaCtrl,
                        'e.g. 80',
                        Icons.monitor_heart_outlined,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        'SpO2 (%)',
                        _o2Ctrl,
                        'e.g. 98',
                        Icons.air_rounded,
                      ),
                    ),
                    SizedBox(width: SizeConfig.widthMultiplier * 3),
                    Expanded(
                      child: _buildField(
                        'Temp (°C)',
                        _tempCtrl,
                        'e.g. 36.6',
                        Icons.thermostat_rounded,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                _buildRow(
                  'Weight (kg)',
                  _weightCtrl,
                  'e.g. 70',
                  Icons.monitor_weight_outlined,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                _buildRow(
                  'Notes (optional)',
                  _notesCtrl,
                  'Any observations...',
                  Icons.notes_rounded,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 3),
                CustomButton(
                  text: 'Save Reading',
                  isLoading: provider.isSaving,
                  onTap: () => _save(context, provider),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(
    String label,
    TextEditingController ctrl,
    String hint,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          size: 12,
          color: AppColors.textMedium,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 0.6),
        _buildField(label, ctrl, hint, icon),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl,
    String hint,
    IconData icon,
  ) {
    return Container(
      height: SizeConfig.heightMultiplier * 6.5,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(
          fontSize: SizeConfig.textMultiplier * 1.6,
          fontFamily: 'Poppins',
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: SizeConfig.textMultiplier * 1.5,
            fontFamily: 'Poppins',
            color: AppColors.iconGrey,
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.iconGrey,
            size: SizeConfig.widthMultiplier * 4.5,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: SizeConfig.heightMultiplier * 1.8,
          ),
        ),
      ),
    );
  }

  void _save(BuildContext context, HealthProvider provider) {
    final hr = int.tryParse(_hrCtrl.text.trim()) ?? 0;
    final sys = int.tryParse(_sysCtrl.text.trim()) ?? 0;
    final dia = int.tryParse(_diaCtrl.text.trim()) ?? 0;
    if (hr == 0 || sys == 0 || dia == 0) return;

    final record = HealthRecordModel(
      id: '',
      patientId: widget.patient.uid,
      caregiverId: SharedPrefsService.getUID() ?? '',
      heartRate: hr,
      systolic: sys,
      diastolic: dia,
      temperature: double.tryParse(_tempCtrl.text.trim()) ?? 0,
      oxygenLevel: int.tryParse(_o2Ctrl.text.trim()) ?? 0,
      weight: double.tryParse(_weightCtrl.text.trim()) ?? 0,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      recordedAt: DateTime.now(),
    );

    provider.addRecord(
      context: context,
      record: record,
      onSuccess: () => Navigator.pop(context),
    );
  }
}
