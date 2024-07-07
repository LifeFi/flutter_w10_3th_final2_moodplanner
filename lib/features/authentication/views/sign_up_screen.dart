import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/common/dev_link.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = "signup";
  static const String routeURL = "/signup";
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: const Center(
        child: DevLink(),
      ),
    );
  }
}
