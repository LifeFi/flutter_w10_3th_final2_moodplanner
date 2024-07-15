import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/view_models/user_profile_view_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/models/mood_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/repos/moods_repo.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/view_models/moods_view_model.dart';

class CreateMoodViewModel extends AsyncNotifier<void> {
  late final MoodsRepository _moodsRepository;

  @override
  FutureOr<void> build() {
    _moodsRepository = ref.read(moodsRepo);
    // _usersRepository = ref.read(userRepo);
    // _authenticationRepository = ref.read(authRepo);
  }

  Future<String> createMood({
    required Timestamp startDate,
    String? task,
    required String moodToDo,
  }) async {
    final user = ref.read(usersProvider).value;
    String docId = "";

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (user == null) return;

      final newMood = MoodModel(
        id: "",
        creatorUid: user.uid,
        creator: user.name,
        startDate: startDate,
        task: task,
        moodToDo: moodToDo,
      );
      docId = await _moodsRepository.createMood(newMood);

      ref.read(moodsProvider.notifier).addFakeMood(
            newMood.copyWith(
              id: docId,
              createdAt: Timestamp.now(),
            ),
          );

      return;
    });

    // ref.read(threadsProvider(null).notifier).refresh();
    return docId;
  }
}

final createMoodProvider = AsyncNotifierProvider<CreateMoodViewModel, void>(
  () => CreateMoodViewModel(),
);
