import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/models/mood_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/repos/moods_repo.dart';

class MoodsViewModel extends AsyncNotifier<List<MoodModel>> {
  late MoodsRepository _moodsRepository;
  late AuthenticationRepository _authenticationRepository;

  List<MoodModel> _list = [];

  Future<List<MoodModel>> fetchMoods({
    String? uid,
  }) async {
    final user = _authenticationRepository.user;
    final result = await _moodsRepository.fetchMoods(
      uid: uid ?? user!.uid,
    );

    final moods = result.docs.map(
      (doc) {
        return MoodModel.fromJson(
          json: doc.data(),
          uid: user?.uid,
        );
      },
    ).toList();

    return moods;
  }

  void addFakeMood(MoodModel newPost) {
    // _list.insert(0, newPost);
    _list.add(newPost);
    state = AsyncValue.data(_list);
  }

  void deleteFakeMood(String moodId) {
    final index = _list.indexWhere((mood) => mood.id == moodId);
    _list.removeAt(index);
    state = AsyncValue.data(_list);
  }

  Future<void> deleteAndShowFakeMood(String moodId) async {
    final index = _list.indexWhere((mood) => mood.id == moodId);
    _list[index].id = "00000000";
    state = AsyncValue.data(_list);
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
    _list.removeAt(index);
    state = AsyncValue.data(_list);
  }

  Future<void> deletetMood(String moodId) async {
    await _moodsRepository.deletetMood(moodId);
  }

  @override
  FutureOr<List<MoodModel>> build() async {
    _moodsRepository = ref.read(moodsRepo);
    _authenticationRepository = ref.read(authRepo);
    _list = await fetchMoods();

    return _list;
  }

  Future<void> refresh() async {
    // state = const AsyncValue.loading();
    _list = await fetchMoods();
    state = AsyncValue.data(_list);
  }
}

final moodsProvider = AsyncNotifierProvider<MoodsViewModel, List<MoodModel>>(
  () => MoodsViewModel(),
);
