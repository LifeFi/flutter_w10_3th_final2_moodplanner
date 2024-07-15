import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/sizes.dart';
import 'package:go_router/go_router.dart';

class DevLink extends StatelessWidget {
  const DevLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => context.go("/signup"),
          child: const Text(
            "SignUp Screen",
            style: TextStyle(fontSize: Sizes.size20),
          ),
        ),
        GestureDetector(
          onTap: () => context.go("/login"),
          child: const Text(
            "Login Screen",
            style: TextStyle(fontSize: Sizes.size20),
          ),
        ),
        GestureDetector(
          onTap: () => context.go("/home"),
          child: const Text(
            "Home Screen",
            style: TextStyle(fontSize: Sizes.size20),
          ),
        ),
      ],
    );
  }
}
