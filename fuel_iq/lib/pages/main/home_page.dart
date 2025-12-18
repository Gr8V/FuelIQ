import 'package:flutter/material.dart';
import 'package:fuel_iq/services/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      //body
      body: CustomScrollView(
        slivers: [
           // 🔹 Scrollable AppBar
          SliverAppBar(
            elevation: 0,
            pinned: false,
            floating: true, // makes it scroll with content
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'Powerlifting App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Performance Meets Precision',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.onSurface.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications, color: colorScheme.primary),
                onPressed: () {
                  NotificationService.showNotification(
                    title: 'TEST NOTIFICATION',
                    body: 'This is a test notification.',
                    );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                
              ),
            ),
          ),
        ]
      )
    );
  }
}