import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/provider/profile.dart';
import 'package:lifelinker/view/profile/components/section_card.dart';
import 'package:lifelinker/view/profile/components/toggle_row.dart';
import 'package:provider/provider.dart';

class NotificationsCard extends StatelessWidget {
  const NotificationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final n = provider.notifications;
        return SectionCard(
          title: 'Notification Settings',
          icon: Icons.notifications_rounded,
          iconColor: AppColors.amber,
          iconBg: AppColors.amberLight,
          children: [
            ToggleRow(
              label: 'SOS Alerts',
              subtitle: 'Critical — always recommended',
              value: n.sosAlerts,
              onChanged: (v) =>
                  provider.updateNotifications(n.copyWith(sosAlerts: v)),
              activeColor: AppColors.alert,
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
            ToggleRow(
              label: 'Geofence Breaches',
              subtitle: 'Patient leaves safe zone',
              value: n.geofenceBreaches,
              onChanged: (v) =>
                  provider.updateNotifications(n.copyWith(geofenceBreaches: v)),
              activeColor: AppColors.blue,
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
            ToggleRow(
              label: 'Medication Reminders',
              subtitle: 'Dose schedule alerts',
              value: n.medicationReminders,
              onChanged: (v) =>
                  provider.updateNotifications(n.copyWith(medicationReminders: v)),
              activeColor: AppColors.successDark,
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
            ToggleRow(
              label: 'Daily Health Summary',
              subtitle: 'Morning health report',
              value: n.dailyHealthSummary,
              onChanged: (v) =>
                  provider.updateNotifications(n.copyWith(dailyHealthSummary: v)),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
            ToggleRow(
              label: 'Low Battery Alerts',
              subtitle: 'Device battery below 20%',
              value: n.lowBattery,
              onChanged: (v) =>
                  provider.updateNotifications(n.copyWith(lowBattery: v)),
            ),
          ],
        );
      },
    );
  }
}