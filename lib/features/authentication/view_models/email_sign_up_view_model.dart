import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/view_models/user_profile_view_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/main_navigation/views/main_navigation_screen.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/view_models/moods_view_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/utils.dart';
import 'package:go_router/go_router.dart';

class EmailSignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;
  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> emailSignUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();
    final user = ref.read(usersProvider.notifier);

    state = await AsyncValue.guard(() async {
      final userCredential = await _authRepo.emailSignUp(
        email,
        password,
      );
      await user.createProfile(userCredential);
    });
    if (!context.mounted) return;
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
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

final signUpForm = StateProvider((ref) => {});

final emailSignUpProvider = AsyncNotifierProvider<EmailSignUpViewModel, void>(
  () => EmailSignUpViewModel(),
);
