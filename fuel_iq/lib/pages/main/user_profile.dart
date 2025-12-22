import 'package:flutter/material.dart';
import 'package:fuel_iq/utils/utils.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      //app bar
      appBar: CustomAppBar(
        title: "profile",
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(colorScheme),
            const SizedBox(height: 24),
            _buildStatsRow(colorScheme),
            const SizedBox(height: 24),
            _buildPRSection(colorScheme),
            const SizedBox(height: 24),
            _buildTrainingInfo(colorScheme),
          ],
        ),
      ),
    );
  }

  // 🔹 Header
  Widget _buildHeader(ColorScheme colorScheme) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.fitness_center,
              size: 36,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Vansh",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Powerlifter • Intermediate",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 🔹 Body stats
  Widget _buildStatsRow(ColorScheme colorScheme) {
    return Row(
      children: [
        _statCard("Weight", "96 kg", colorScheme),
        _statCard("Body Fat", "24.8%", colorScheme),
        _statCard("Total", "560 kg", colorScheme),
      ],
    );
  }

  Widget _statCard(String label, String value, ColorScheme colorScheme) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 PR Section
  Widget _buildPRSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Personal Records",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _prTile("Squat", "180 kg"),
        _prTile("Bench Press", "120 kg"),
        _prTile("Deadlift", "260 kg"),
      ],
    );
  }

  Widget _prTile(String lift, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.check_circle_outline),
      title: Text(lift),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // 🔹 Training info
  Widget _buildTrainingInfo(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Training Info",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.calendar_today),
          title: Text("Experience"),
          trailing: Text("2+ years"),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.flag),
          title: Text("Federation"),
          trailing: Text("IPF-style"),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.track_changes),
          title: Text("Current Goal"),
          trailing: Text("600 kg total"),
        ),
      ],
    );
  }
}