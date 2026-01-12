import 'package:flutter/material.dart';
import 'package:fuel_iq/pages/main/settings/language.dart';
import 'package:fuel_iq/pages/main/settings/targets.dart';
import 'package:fuel_iq/pages/main/settings/notifications.dart';
import 'package:fuel_iq/pages/main/settings/sign_out.dart';
import 'package:fuel_iq/pages/main/settings/theme.dart';
import 'package:fuel_iq/pages/main/settings/user_profile.dart';
import 'package:fuel_iq/providers/daily_data_provider.dart';
import 'package:fuel_iq/providers/saved_foods_provider.dart';
import 'package:fuel_iq/utils/utils.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    //final colorScheme = theme.colorScheme;
    return Scaffold(
      //app bar
      appBar: CustomAppBar(title: "settings", showBack: false,),
      //body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SettingsSection(
              title: 'General',
              children: [
                SettingsCardTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    pushWithSlideFade(context, Notifications());
                  },
                ),
                SettingsCardTile(
                  icon: Icons.color_lens,
                  title: 'Theme',
                  onTap: () {
                    pushWithSlideFade(context, ThemeSelectionPage());
                  },
                ),
                SettingsCardTile(
                  icon: Icons.language,
                  title: 'Language',
                  onTap: () {
                    pushWithSlideFade(context, Language());
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Training & Nutrition',
              children: [
                SettingsCardTile(
                  icon: Icons.flag,
                  title: 'Targets',
                  onTap: () {
                    pushWithSlideFade(context, TargetSelectionPage());
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Account',
              children: [
                SettingsCardTile(
                  icon: Icons.person,
                  title: 'User Profile',
                  onTap: () {
                    pushWithSlideFade(context, UserProfile());
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Danger Zone',
              children: [
                SettingsCardTile(
                  icon: Icons.delete_forever,
                  bgColor: Colors.red,
                  title: 'Erase All Data',
                  onTap: () {
                    showEraseDataDialog(context: context);
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Log Out',
              children: [
                SettingsCardTile(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  onTap: () {
                    pushWithSlideFade(context, SignOut());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? bgColor;

  const SettingsCardTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8,),
      elevation: 3,
      color: bgColor ?? colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                ),
              ),

              const SizedBox(width: 16),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.secondary,
            ),
          ),
        ),
        Column(children: children),
      ],
    );
  }
}


Future<void> showEraseDataDialog({
  required BuildContext context,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;

      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Delete All Data',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        content: const Text(
          "Are you sure you want to permanently delete all your data? This action cannot be undone.",
          style: TextStyle(fontSize: 15.5),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),

          // DELETE BUTTON
          ElevatedButton(
            onPressed: () async {
              final dailyProvider = Provider.of<DailyDataProvider>(
                context,
                listen: false,
              );
              final savedFoodsProvider = Provider.of<SavedFoodsProvider>(
                context,
                listen: false,
              );

              // Clear ALL user data
              await dailyProvider.clearAll();
              await savedFoodsProvider.clearAll();

              // Reinitialize daily data (autofill today)
              await dailyProvider.reinitialize();

              if (!context.mounted) return;

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('All data cleared successfully'),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Delete All',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
