import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/models/mood_model.dart';

class MoodsRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchMoods({
    String? uid,
  }) async {
    // print("fetchThreads: $uid");
    // await Future.delayed(const Duration(seconds: 2));
    Query<Map<String, dynamic>> query;

    if (uid == null) {
      query = _db.collection("moods").orderBy("createdAt", descending: false);
    } else {
      query = _db
          .collection("moods")
          .where("creatorUid", isEqualTo: uid)
          .orderBy("createdAt", descending: false);
    }

    return query.get();
  }

  Future<String> createMood(MoodModel data) async {
    final newMoodRef = _db.collection("moods").doc();

    await newMoodRef.set(
      {
        ...data.toJson(),
        "createdAt": FieldValue.serverTimestamp(),
        "id": newMoodRef.id,
      },
    );
    return newMoodRef.id;
  }

  Future<void> updateMood(String moodId, Map<String, dynamic> data) async {
    await _db.collection("moods").doc(moodId).update(
      {
        ...data,
        "updatedAt": FieldValue.serverTimestamp(),
      },
    );
  }

  Future<void> deletetMood(String moodId) async {
    final deleteRef = _db.collection("moods").doc(moodId);

    await deleteRef.delete();
  }
}

final moodsRepo = Provider(
  (ref) => MoodsRepository(),
);
