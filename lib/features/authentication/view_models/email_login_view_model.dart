import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/view_models/user_profile_view_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/main_navigation/views/main_navigation_screen.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/view_models/moods_view_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/utils.dart';

import 'package:go_router/go_router.dart';

class EmailLoginViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;
  @override
  FutureOr<void> build() async {
    _repository = ref.read(authRepo);
  }

  Future<void> emailLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => await _repository.emailSignIn(email, password),
    );
    print(state.error);
    if (state.hasError && context.mounted) {
      showFirebaseErrorSnack(context, state.error);
    } else if (context.mounted) {
      ref.container.refresh(authRepo);
      ref.container.refresh(moodsProvider);
      ref.container.refresh(usersProvider);
      // ref.read(recentLoginEmailProvider.notifier).resetLoginEmail(email);
      if (context.mounted) {
        context.goNamed(
          MainNavigationScreen.routeName,
          pathParameters: {"tab": "home"},
        );
      }
    }
  }
}

final emailLoginProvider = AsyncNotifierProvider<EmailLoginViewModel, void>(
  () => EmailLoginViewModel(),
);
