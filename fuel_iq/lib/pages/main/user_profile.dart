import 'package:flutter/material.dart';

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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            //app bar
            AppBar(
              title:Text(
                'Profile', // Replace with your app name
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  height: 1.2,
                  fontFamily: 'serif', // Gives it an elegant look
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 8,
                    ),
                    Shadow(
                      color: Colors.white24,
                      offset: Offset(0, -1),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
            Divider(
              thickness: 2,        // line thickness
              color: Colors.grey,  // line color
            ),
          ],
        ),
      ),
    );
  }
}