import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/view_models/user_profile_view_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/models/mood_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/repos/moods_repo.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/view_models/moods_view_model.dart';

class UpdateMoodViewModel extends AsyncNotifier<void> {
  late final MoodsRepository _moodsRepository;

  @override
  FutureOr<void> build() {
    _moodsRepository = ref.read(moodsRepo);
    // _usersRepository = ref.read(userRepo);
    // _authenticationRepository = ref.read(authRepo);
  }

  Future<void> updateMood({
    required String moodId,
    required Timestamp startDate,
    String? task,
    required String moodToDo,
    String? moodDone,
  }) async {
    final user = ref.read(usersProvider).value;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        if (user == null) return;

        await _moodsRepository.updateMood(
          moodId,
          {
            "startDate": startDate,
            "task": task ?? "",
            "moodToDo": moodToDo,
            "moodDone": moodDone ?? "",
            "isDone": moodDone != null,
          },
        );
      },
    );
    ref.read(moodsProvider.notifier).refresh();
  }
}

final updateMoodProvider = AsyncNotifierProvider<UpdateMoodViewModel, void>(
  () => UpdateMoodViewModel(),
);
