import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/views/login_screen.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/views/sign_up_screen.dart';

import 'package:flutter_w10_3th_final2_moodplanner/features/main_navigation/views/main_navigation_screen.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider(
  (ref) {
    // ref.watch(authState);
    return GoRouter(
      initialLocation: "/home",
      routes: [
        GoRoute(
          name: SignUpScreen.routeName,
          path: SignUpScreen.routeURL,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          name: LoginScreen.routeName,
          path: LoginScreen.routeURL,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: MainNavigationScreen.routeURL, // "/:tab(home|post)"
          name: MainNavigationScreen.routeName,
          builder: (context, state) {
            final tab = state.pathParameters["tab"]!;
            return MainNavigationScreen(tab: tab);
          },
        ),
      ],
    );
  },
);
