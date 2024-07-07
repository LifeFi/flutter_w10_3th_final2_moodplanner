import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/common/dev_link.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "home";
  static const String routeURL = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: DevLink(),
      ),
    );
  }
}
