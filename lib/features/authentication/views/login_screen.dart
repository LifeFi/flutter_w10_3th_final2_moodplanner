import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/common/dev_link.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "login";
  static const String routeURL = "/login";
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const Center(
        child: DevLink(),
      ),
    );
  }
}
