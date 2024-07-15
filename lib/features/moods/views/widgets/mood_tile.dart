import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/gaps.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/sizes.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/models/mood_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/view_models/moods_view_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/views/update_mood_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MoodTile extends ConsumerStatefulWidget {
  final MoodModel mood;
  const MoodTile({
    super.key,
    required this.mood,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MoodTileState();
}

class _MoodTileState extends ConsumerState<MoodTile> {
  void _showDeleteBottomsheet(String moodId) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text(
            "무드 플랜을 삭제하시겠습니까?",
            style: TextStyle(
              fontSize: Sizes.size18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                _onDeleteTap(moodId);
                Navigator.of(context).pop();
              },
              child: const Text(
                "삭제",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("취소"),
          ),
        );
      },
    );
  }

  void _onDeleteTap(String moodId) {
    ref.read(moodsProvider.notifier).deletetMood(moodId);
    ref.read(moodsProvider.notifier).deleteAndShowFakeMood(moodId);
  }

  void _showUpdateBottomSheet(MoodModel mood) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      // showDragHandle: true,
      elevation: 0,
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: UpdateMoodScreen(mood: mood),
      ),
      backgroundColor: Colors.white,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Sizes.size16),
          topRight: Radius.circular(Sizes.size16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final startDate = widget.mood.startDate.toDate();
    final startTimeString =
        "${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}";

    return GestureDetector(
      onLongPress: () => _showDeleteBottomsheet(widget.mood.id),
      onTap: () => _showUpdateBottomSheet(widget.mood),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size10,
        ),
        child: Row(
          children: [
            Container(
              width: Sizes.size96,
              height: Sizes.size48,
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.mood.isDone ? Colors.green : Colors.grey,
                ),
                color:
                    widget.mood.isDone ? Colors.green.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(
                  Sizes.size48,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -5,
                    left: 1,
                    child: Row(
                      children: [
                        Text(
                          widget.mood.moodToDo,
                          style: const TextStyle(
                            fontSize: Sizes.size40,
                          ),

                          // textScaler: const TextScaler.linear(1.5),
                        ),
                        Gaps.h3,
                        const FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: Sizes.size10,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  widget.mood.isDone
                      ? Positioned(
                          top: -5,
                          right: 1,
                          child: Text(
                            widget.mood.moodDone!,
                            style: const TextStyle(
                              fontSize: Sizes.size40,
                            ),
                          ),
                        )
                      : Positioned(
                          top: 5,
                          right: 3,
                          child: Container(
                            width: Sizes.size36,
                            height: Sizes.size36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade100,
                            ),
                            child: FaIcon(
                              FontAwesomeIcons.check,
                              size: Sizes.size28,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Gaps.h5,
            Text(
              startTimeString,
              style: const TextStyle(
                fontSize: Sizes.size18,
                color: Colors.grey,
              ),
            ),
            Gaps.h10,
            Expanded(
              child: Text(
                widget.mood.task ?? "",
                style: const TextStyle(
                  fontSize: Sizes.size18,
                ),
              ),
            ),
            const FaIcon(
              FontAwesomeIcons.ellipsisVertical,
              size: Sizes.size16,
              color: Colors.grey,
            ),
            Gaps.h10,
          ],
        ),
      ),
    );
  }
}
