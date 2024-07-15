import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create profile
  Future<void> createProfile(UserProfileModel profile) async {
    final newProfileRef = _db.collection("users").doc(profile.uid);
    await newProfileRef.set({
      ...profile.toJson(),
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // get profile
  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }
}

final userRepo = Provider(
  (ref) => UserRepository(),
);
