import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/models/user_profile_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late UserRepository _usersRepository;
  late AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _usersRepository = ref.watch(userRepo);
    _authenticationRepository = ref.watch(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final user = _authenticationRepository.user;
      final profile = await _usersRepository.findProfile(user!.uid);

      if (profile != null) {
        return UserProfileModel.fromJson(
          json: profile,
          uid: user.uid,
        );
      }
    }
    return UserProfileModel.empty();
  }

  Future<UserProfileModel?> findProfile(String uid) async {
    final profile = await _usersRepository.findProfile(uid);
    if (profile != null) {
      return UserProfileModel.fromJson(
        json: profile,
        uid: uid,
      );
    }
    return null;
  }

  Future<void> createProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    state = const AsyncValue.loading();

    final profile = UserProfileModel(
      uid: credential.user!.uid,
      email: credential.user!.email ?? "anon@anon.com",
      name: credential.user!.displayName ??
          (credential.user!.email?.split("@")[0] ?? "anon"),
    );
    await _usersRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
