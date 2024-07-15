import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final Timestamp? createdAt;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    this.createdAt,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        createdAt = null;

  UserProfileModel.fromJson({
    required Map<String, dynamic> json,
    required String uid,
  })  : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        createdAt = json["createdAt"];

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "createdAt": createdAt,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? email,
    String? name,
    Timestamp? createdAt,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
