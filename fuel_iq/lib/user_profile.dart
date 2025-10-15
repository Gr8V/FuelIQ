import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        //app title
        title: const Text('FuelIQ'),
        centerTitle: true,
        
      ),
    );
  }
}