import 'package:flutter/material.dart';
import 'package:fuel_iq/utils/utils.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "notifications"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}