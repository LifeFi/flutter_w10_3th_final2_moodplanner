import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/gaps.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/sizes.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/view_models/create_mood_view_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/utils.dart';
import 'package:go_router/go_router.dart';

class CreateMoodScreen extends ConsumerStatefulWidget {
  const CreateMoodScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateMoodScreenState();
}

class _CreateMoodScreenState extends ConsumerState<CreateMoodScreen> {
  final TextEditingController _dateTimeController =
      TextEditingController(text: DateTime.now().toString());
  final TextEditingController _taskController = TextEditingController();

  late DateTime _today;
  late DateTime _initialDateTime;
  late DateTime _dateTime;

  int? _selectedMoodEmojiIndex;
  final List<String> _moodEmojiList = [
    "😀",
    "😍",
    "😊",
    "🥳",
    "😭",
  ];
  @override
  void initState() {
    super.initState();

    _today = DateTime.now();
    _initialDateTime = DateTime(
      _today.year,
      _today.month,
      _today.day,
    );
    _dateTime = _initialDateTime;
  }

  _selectMoodEmoji(int index) {
    setState(() {
      _selectedMoodEmojiIndex = index;
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
        setState(() {});
      },
    );
  }

  bool _validator() {
    if (_selectedMoodEmojiIndex != null &&
        _selectedMoodEmojiIndex! < _moodEmojiList.length) {
      return true;
    }
    return false;
  }

  void _onCreateMoodPlanTap() {
    if (!_validator()) return;
    ref.read(createMoodProvider.notifier).createMood(
          startDate: Timestamp.fromDate(_dateTime),
          task: _taskController.text,
          moodToDo: _moodEmojiList[_selectedMoodEmojiIndex!],
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    print(_initialDateTime);
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.grey[100],
            title: const Text(
              "새로운 무드 플랜",
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
                onTap: _validator() ? _onCreateMoodPlanTap : () {},
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(right: Sizes.size16),
                  child: Text(
                    "추가",
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
                              onTap: () => _selectMoodEmoji(index),
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
                                  child: _selectedMoodEmojiIndex == index
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
