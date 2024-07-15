import 'package:cloud_firestore/cloud_firestore.dart';

class MoodModel {
  String id;
  String creatorUid;
  String creator;
  String? task;
  String moodToDo;
  String? moodDone;
  bool isDone;
  Timestamp startDate;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  MoodModel({
    required this.id,
    required this.creatorUid,
    required this.creator,
    this.task,
    required this.moodToDo,
    this.moodDone,
    this.isDone = false,
    required this.startDate,
    this.createdAt,
    this.updatedAt,
  });

  MoodModel.fromJson({
    required Map<String, dynamic> json,
    String? uid,
  })  : id = json["id"],
        creatorUid = json["creatorUid"],
        creator = json["creator"],
        task = json["task"],
        moodToDo = json["moodToDo"],
        moodDone = json["moodDone"],
        isDone = json["isDone"],
        startDate = json["startDate"],
        createdAt = json["createdAt"],
        updatedAt = json["updatedAt"];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "creatorUid": creatorUid,
      "creator": creator,
      "task": task,
      "moodToDo": moodToDo,
      "moodDone": moodDone,
      "isDone": isDone,
      "startDate": startDate,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  MoodModel copyWith({
    String? id,
    String? creatorUid,
    String? creator,
    String? task,
    String? moodToDo,
    String? moodDone,
    bool? isDone,
    Timestamp? startDate,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return MoodModel(
      id: id ?? this.id,
      creatorUid: creatorUid ?? this.creatorUid,
      creator: creator ?? this.creator,
      task: task ?? this.task,
      moodToDo: moodToDo ?? this.moodToDo,
      moodDone: moodDone ?? this.moodDone,
      isDone: isDone ?? this.isDone,
      startDate: startDate ?? this.startDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
