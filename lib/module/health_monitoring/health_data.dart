import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/shared/app_text.dart';
import 'package:lifelinker/core/utils/size_utils.dart';

class HealthDataView extends StatefulWidget {
  const HealthDataView({super.key});

  @override
  State<HealthDataView> createState() => _HealthDataViewState();
}

class _HealthDataViewState extends State<HealthDataView> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.h),
              child: Column(
                children: [
                  _buildStepsCard(),
                  Gap.v(14),
                  _buildHeartRateCard(),
                  Gap.v(14),
                  _buildSleepCard(),
                  Gap.v(14),
                  _buildActivityCard(),
                  Gap.v(14),
                  _buildWeeklyOverviewCard(),
                  Gap.v(24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── App Bar ───────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4DA3FF), Color(0xFF2A7FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.chevron_left_rounded,
                    color: Colors.white, size: 28.h),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: AppText(
                  'Health Data',
                  size: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  align: TextAlign.center,
                ),
              ),
              Icon(Icons.info_outline_rounded,
                  color: Colors.white, size: 22.h),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Steps Card ────────────────────────────────────────────────────────────

  Widget _buildStepsCard() {
    const double progress = 0.74; // 1482 / 2000
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText('Steps',
                  size: 16,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText('1,482',
                      size: 22,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700),
                  AppText('Set 2000',
                      size: 11,
                      color: AppColors.iconGrey,
                      fontWeight: FontWeight.w400),
                ],
              ),
            ],
          ),
          Gap.v(6),
          AppText('Goal of 2,000',
              size: 12, color: AppColors.iconGrey),
          Gap.v(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10.v,
              backgroundColor: AppColors.border,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
          ),
          Gap.v(6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText('0', size: 11, color: AppColors.iconGrey),
              AppText('2,000', size: 11, color: AppColors.iconGrey),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Heart Rate Card ───────────────────────────────────────────────────────

  Widget _buildHeartRateCard() {
    // Mock BPM data points
    final List<double> bpmPoints = [
      68, 72, 75, 71, 74, 80, 76, 72, 69, 73,
      78, 82, 75, 70, 72, 76, 71, 74, 72, 70,
    ];

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText('Heart Rate',
                  size: 16,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText('72',
                          size: 22,
                          color: AppColors.success,
                          fontWeight: FontWeight.w700),
                      AppText('BPM',
                          size: 12,
                          color: AppColors.success,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                  AppText('12 mins ago',
                      size: 11,
                      color: AppColors.iconGrey),
                ],
              ),
            ],
          ),
          Gap.v(14),
          SizedBox(
            height: 80.v,
            child: CustomPaint(
              size: Size(double.infinity, 80.v),
              painter: _HeartRateChartPainter(points: bpmPoints),
            ),
          ),
          Gap.v(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHRStat('Min', '65', AppColors.primary),
              _buildHRStat('Avg', '72', AppColors.success),
              _buildHRStat('Max', '82', AppColors.alert),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHRStat(String label, String value, Color color) {
    return Column(
      children: [
        AppText(value,
            size: 15,
            color: color,
            fontWeight: FontWeight.w700),
        AppText(label,
            size: 11,
            color: AppColors.iconGrey),
      ],
    );
  }

  // ─── Sleep Card ────────────────────────────────────────────────────────────

  Widget _buildSleepCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText('Sleep',
                  size: 16,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText('7.2',
                      size: 22,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700),
                  AppText('h',
                      size: 14,
                      color: AppColors.iconGrey,
                      fontWeight: FontWeight.w500),
                ],
              ),
            ],
          ),
          Gap.v(4),
          AppText('Sleep calories   3.4 hr m',
              size: 12, color: AppColors.iconGrey),
          Gap.v(10),

          // Sleep stages bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                _buildSleepSegment(0.15, const Color(0xFF1A5FCC)), // Deep
                _buildSleepSegment(0.45, AppColors.primary),       // Core
                _buildSleepSegment(0.25, const Color(0xFF90C4FF)), // REM
                _buildSleepSegment(0.15, AppColors.border),        // Awake
              ],
            ),
          ),
          Gap.v(10),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSleepLegend('Deep', const Color(0xFF1A5FCC)),
              _buildSleepLegend('Core', AppColors.primary),
              _buildSleepLegend('REM', const Color(0xFF90C4FF)),
              _buildSleepLegend('Awake', AppColors.iconGrey),
            ],
          ),

          Gap.v(12),
          Divider(color: AppColors.divider, height: 1),
          Gap.v(12),

          // Sleep time row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSleepTime(Icons.bedtime_rounded, 'Bedtime', '10:30 PM'),
              Container(width: 1, height: 32.v, color: AppColors.divider),
              _buildSleepTime(Icons.wb_sunny_rounded, 'Wake up', '6:45 AM'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepSegment(double flex, Color color) {
    return Expanded(
      flex: (flex * 100).toInt(),
      child: Container(height: 10.v, color: color),
    );
  }

  Widget _buildSleepLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10.h,
          height: 10.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.h),
        AppText(label, size: 11, color: AppColors.iconGrey),
      ],
    );
  }

  Widget _buildSleepTime(IconData icon, String label, String time) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18.h),
        SizedBox(width: 8.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(label, size: 11, color: AppColors.iconGrey),
            AppText(time,
                size: 13,
                color: AppColors.textDark,
                fontWeight: FontWeight.w600),
          ],
        ),
      ],
    );
  }

  // ─── Activity Card ─────────────────────────────────────────────────────────

  Widget _buildActivityCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('Activity',
              size: 16,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600),
          Gap.v(14),
          Row(
            children: [
              _buildActivityStat(
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.alert,
                value: '320',
                unit: 'kcal',
                label: 'Calories',
              ),
              SizedBox(width: 10.h),
              _buildActivityStat(
                icon: Icons.directions_walk_rounded,
                iconColor: AppColors.primary,
                value: '2.4',
                unit: 'km',
                label: 'Distance',
              ),
              SizedBox(width: 10.h),
              _buildActivityStat(
                icon: Icons.timer_rounded,
                iconColor: AppColors.success,
                value: '42',
                unit: 'min',
                label: 'Active',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityStat({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String unit,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.v),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22.h),
            Gap.v(6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(value,
                    size: 15,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700),
                AppText(unit,
                    size: 10,
                    color: AppColors.iconGrey),
              ],
            ),
            Gap.v(2),
            AppText(label,
                size: 11,
                color: AppColors.iconGrey),
          ],
        ),
      ),
    );
  }

  // ─── Weekly Overview Card ──────────────────────────────────────────────────

  Widget _buildWeeklyOverviewCard() {
    final List<Map<String, dynamic>> weekData = [
      {'day': 'Mon', 'steps': 0.6, 'active': true},
      {'day': 'Tue', 'steps': 0.8, 'active': true},
      {'day': 'Wed', 'steps': 0.45, 'active': false},
      {'day': 'Thu', 'steps': 0.9, 'active': true},
      {'day': 'Fri', 'steps': 0.74, 'active': true},
      {'day': 'Sat', 'steps': 0.3, 'active': false},
      {'day': 'Sun', 'steps': 0.55, 'active': false},
    ];

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText('Weekly Overview',
                  size: 16,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600),
              AppText('Steps',
                  size: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500),
            ],
          ),
          Gap.v(16),
          SizedBox(
            height: 80.v,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekData.map((d) {
                final bool isToday = d['day'] == 'Fri';
                return _buildBarColumn(
                  day: d['day'],
                  heightFraction: d['steps'],
                  isToday: isToday,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarColumn({
    required String day,
    required double heightFraction,
    required bool isToday,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28.h,
          height: (60 * heightFraction).v,
          decoration: BoxDecoration(
            color: isToday
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.25),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        Gap.v(6),
        AppText(
          day,
          size: 10,
          color: isToday ? AppColors.primary : AppColors.iconGrey,
          fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
        ),
      ],
    );
  }

  // ─── Base Card ─────────────────────────────────────────────────────────────

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

// ─── Heart Rate Chart Painter ──────────────────────────────────────────────

class _HeartRateChartPainter extends CustomPainter {
  final List<double> points;

  const _HeartRateChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final double minVal = points.reduce((a, b) => a < b ? a : b) - 5;
    final double maxVal = points.reduce((a, b) => a > b ? a : b) + 5;
    final double range = maxVal - minVal;

    double normalize(double v) => (v - minVal) / range;

    final List<Offset> offsets = List.generate(points.length, (i) {
      final dx = (i / (points.length - 1)) * size.width;
      final dy = size.height - normalize(points[i]) * size.height;
      return Offset(dx, dy);
    });

    // Fill gradient
    final fillPath = Path();
    fillPath.moveTo(0, size.height);
    for (final o in offsets) {
      fillPath.lineTo(o.dx, o.dy);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.success.withOpacity(0.3),
          AppColors.success.withOpacity(0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePath = Path();
    linePath.moveTo(offsets.first.dx, offsets.first.dy);
    for (int i = 1; i < offsets.length; i++) {
      final prev = offsets[i - 1];
      final curr = offsets[i];
      final cpx = (prev.dx + curr.dx) / 2;
      linePath.cubicTo(cpx, prev.dy, cpx, curr.dy, curr.dx, curr.dy);
    }

    canvas.drawPath(linePath, linePaint);

    // Current dot
    final dotPaint = Paint()..color = AppColors.success;
    canvas.drawCircle(offsets.last, 4, dotPaint);
    final dotBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(offsets.last, 4, dotBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}