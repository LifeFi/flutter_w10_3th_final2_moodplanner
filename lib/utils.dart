import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String getImage() {
  final random = Random();
  return 'https://picsum.photos/300/200?hash=${random.nextInt(10000)}';
}

String imageUrl(String imagePath, {bool isCached = false}) {
  return "https://firebasestorage.googleapis.com/v0/b/flutter_w10_3th_final2.appspot.com/o/${imagePath.replaceAll("/", "%2F")}?alt=media&haha=${isCached ? DateTime.now().toString() : ""}";
}

String diffTimeString({required DateTime dateTime, bool isLong = false}) {
  final curTime = DateTime.now();
  final diffMSec =
      curTime.millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;
  String result;

  if (diffMSec < 60 * 1000) {
    result = "Just now";
  } else if (diffMSec < 60 * 60 * 1000) {
    result =
        "${(diffMSec / (60 * 1000)).round()}${isLong ? " minutes ago" : "m"}";
  } else if (diffMSec < 24 * 60 * 60 * 1000) {
    result =
        "${(diffMSec / (60 * 60 * 1000)).round()}${isLong ? " hours ago" : "h"}";
  } else {
    result =
        "${(diffMSec / (24 * 60 * 60 * 1000)).round()}${isLong ? " days ago" : "d"}";
  }
  return result;
}

String dateTimeFormat(DateTime dateTime) {
  return "${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}

String dateFormat(DateTime dateTime) {
  return "${dateTime.year}월 ${dateTime.month}월 ${dateTime.day}일";
}

String shortNumberFormat(int number) {
  if (number > 1000000000) {
    return "${(number / 1000000).toStringAsFixed(1)}B";
  } else if (number > 1000000) {
    return "${(number / 1000000).toStringAsFixed(1)}M";
  } else if (number > 1000) {
    return "${(number / 1000).toStringAsFixed(1)}K";
  }

  return number.toString();
}

bool isDarkMode(BuildContext context, ThemeMode themeMode) {
  switch (themeMode) {
    case ThemeMode.system:
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    case ThemeMode.dark:
      return true;
    case ThemeMode.light:
      return false;
    default:
      return false;
  }
}

void showFirebaseErrorSnack(
  BuildContext context,
  Object? error,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      content:
          // Text((error as FirebaseException).message ?? "Something went wrong."),
          Text("${(error is FirebaseException ? error.code : error)}"),
    ),
  );
}
