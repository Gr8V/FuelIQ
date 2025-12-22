import 'package:flutter/material.dart';
import 'package:fuel_iq/utils/utils.dart';

class SignOut extends StatefulWidget {
  const SignOut({super.key});

  @override
  State<SignOut> createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "sign out"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}