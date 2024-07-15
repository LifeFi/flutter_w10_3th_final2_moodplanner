import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/gaps.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/sizes.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/models/mood_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/view_models/create_mood_view_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/view_models/update_mood_view_mode.dart';
import 'package:flutter_w10_3th_final2_moodplanner/utils.dart';
import 'package:go_router/go_router.dart';

class UpdateMoodScreen extends ConsumerStatefulWidget {
  final MoodModel mood;
  const UpdateMoodScreen({
    super.key,
    required this.mood,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateMoodScreenState();
}

class _UpdateMoodScreenState extends ConsumerState<UpdateMoodScreen> {
  late final TextEditingController _taskController = TextEditingController(
    text: widget.mood.task,
  );

  late DateTime _initialDateTime;
  late DateTime _dateTime;

  int? _selectedMoodToDoEmojiIndex;
  int? _selectedMoodDoneEmojiIndex;
  final List<String> _moodEmojiList = [
    "😀",
    "😍",
    "😊",
    "🥳",
    "😭",
  ];
  late bool _isChanged;

  @override
  void initState() {
    super.initState();
    _initialDateTime = widget.mood.startDate.toDate();
    _dateTime = _initialDateTime;
    _selectedMoodToDoEmojiIndex = _moodEmojiList.indexOf(widget.mood.moodToDo);
    _selectedMoodDoneEmojiIndex = widget.mood.moodDone != null
        ? _moodEmojiList.indexOf(widget.mood.moodDone!)
        : null;
    _isChanged = false;
    _taskController.addListener(() {
      setState(() {
        _isChanged = true;
      });
    });
  }

  _selectMoodToDoEmoji(int index) {
    setState(() {
      _isChanged = true;
      _selectedMoodToDoEmojiIndex = index;
    });
  }

  _selectMoodDoneEmoji(int index) {
    setState(() {
      _isChanged = true;
      _selectedMoodDoneEmojiIndex = index;
    });
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  _showDateTimePicker() {
    setState(() {});
    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.white.withOpacity(0),
      builder: (context) {
        return SizedBox(
          height: 200.0,
          width: double.infinity,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: _dateTime,
            minuteInterval: 10,
            use24hFormat: true,
            // onDateTimeChanged: _setTextFieldDate,
            onDateTimeChanged: (value) => {_dateTime = value},
            backgroundColor: Colors.white,
          ),
        );
      },
    ).then(
      (value) {
        setState(() {
          _isChanged = true;
        });
      },
    );
  }

  bool _validator() {
    if (_isChanged) {
      return true;
    }

    return false;
  }

  void _onUpdateMoodPlanTap() {
    if (!_validator()) return;
    ref.read(updateMoodProvider.notifier).updateMood(
          moodId: widget.mood.id,
          startDate: Timestamp.fromDate(_dateTime),
          task: _taskController.text,
          moodToDo: _moodEmojiList[_selectedMoodToDoEmojiIndex!],
          moodDone: _selectedMoodDoneEmojiIndex != null
              ? _moodEmojiList[_selectedMoodDoneEmojiIndex!]
              : null,
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.grey[100],
            title: const Text(
              "무드 플랜",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: Sizes.size16),
                child: const Text(
                  "취소",
                  style: TextStyle(
                    fontSize: Sizes.size20,
                  ),
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: _validator() ? _onUpdateMoodPlanTap : () {},
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(right: Sizes.size16),
                  child: Text(
                    "완료",
                    style: TextStyle(
                        fontSize: Sizes.size20,
                        color: _validator() ? Colors.blue : Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size10,
            ),
            child: Column(
              children: [
                Gaps.v10,
                GestureDetector(
                  onTap: _showDateTimePicker,
                  child: Container(
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                      vertical: Sizes.size5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size10,
                      vertical: Sizes.size10,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.size10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${dateTimeFormat(_dateTime)} ▼",
                          style: TextStyle(
                            fontSize: Sizes.size18,
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gaps.v10,
                TextField(
                  textInputAction: TextInputAction.next,
                  controller: _taskController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size10,
                    ),
                    hintText: "할일/약속",
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(Sizes.size10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(Sizes.size10),
                    ),
                  ),
                ),
                Gaps.v10,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size10,
                    vertical: Sizes.size10,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(Sizes.size10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "어떤 기분을 계획하고 있나요?",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int index = 0;
                              index < _moodEmojiList.length;
                              index++)
                            GestureDetector(
                              onTap: () => _selectMoodToDoEmoji(index),
                              child: Container(
                                width: Sizes.size56,
                                height: Sizes.size56,
                                alignment: Alignment.bottomCenter,
                                margin: const EdgeInsets.all(Sizes.size3),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  // color: Colors.blue,
                                ),
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: _selectedMoodToDoEmojiIndex == index
                                      ? Text(
                                          _moodEmojiList[index],
                                          style: const TextStyle(
                                            fontSize: Sizes.size44,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : ColorFiltered(
                                          colorFilter: const ColorFilter.mode(
                                            Colors.grey,
                                            BlendMode.saturation,
                                          ),
                                          child: Text(
                                            _moodEmojiList[index],
                                            style: const TextStyle(
                                              fontSize: Sizes.size32,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Gaps.v10,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size10,
                    vertical: Sizes.size10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Sizes.size10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "실제로 어떤 기분으로 보내셨나요?",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int index = 0;
                              index < _moodEmojiList.length;
                              index++)
                            GestureDetector(
                              onTap: () => _selectMoodDoneEmoji(index),
                              child: Container(
                                width: Sizes.size56,
                                height: Sizes.size56,
                                alignment: Alignment.bottomCenter,
                                margin: const EdgeInsets.all(Sizes.size3),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  // color: Colors.blue,
                                ),
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: _selectedMoodDoneEmojiIndex == index
                                      ? Text(
                                          _moodEmojiList[index],
                                          style: const TextStyle(
                                            fontSize: Sizes.size44,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : ColorFiltered(
                                          colorFilter: const ColorFilter.mode(
                                            Colors.grey,
                                            BlendMode.saturation,
                                          ),
                                          child: Text(
                                            _moodEmojiList[index],
                                            style: const TextStyle(
                                              fontSize: Sizes.size32,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
