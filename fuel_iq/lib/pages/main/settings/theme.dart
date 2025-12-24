import 'package:flutter/material.dart';
import 'package:fuel_iq/globals/theme_controller.dart';
import 'package:fuel_iq/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return Scaffold(
          appBar: CustomAppBar(title: "Theme"),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                "appearance".toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                margin: EdgeInsets.zero,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _ThemeRadios(currentTheme),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeRadios extends StatelessWidget {
  final ThemeMode currentTheme;
  const _ThemeRadios(this.currentTheme);

  @override
  Widget build(BuildContext context) {
    return RadioGroup<ThemeMode>(
      groupValue: currentTheme,
      onChanged: (value) {
        if (value != null) {
          setTheme(value);
        }
      },
      child: Column(
        children: const [
          _ThemeTile(
            value: ThemeMode.light,
            title: "Light",
            subtitle: "Bright and clean appearance",
            icon: Icons.light_mode_rounded,
          ),
          _ThemeTile(
            value: ThemeMode.dark,
            title: "Dark",
            subtitle: "Easy on the eyes at night",
            icon: Icons.dark_mode_rounded,
          ),
          _ThemeTile(
            value: ThemeMode.system,
            title: "System",
            subtitle: "Matches device settings",
            icon: Icons.settings_rounded,
          ),
        ],
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final ThemeMode value;
  final String title;
  final String subtitle;
  final IconData icon;

  const _ThemeTile({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return RadioListTile<ThemeMode>(
      value: value,
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600
          ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(),
      ),
      secondary: CircleAvatar(
          backgroundColor: colorScheme.secondary.withValues(alpha: 0.5),
          child: Icon(icon, color: colorScheme.primary),
        ),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
