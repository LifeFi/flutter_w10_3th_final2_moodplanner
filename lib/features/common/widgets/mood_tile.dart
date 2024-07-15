import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/gaps.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/sizes.dart';
import 'package:flutter_w10_3th_final2_moodplanner/utils.dart';

class MoodTile extends StatefulWidget {
  final String text;
  final DateTime createdAt;
  final Function fn;
  final String moodId;

  const MoodTile({
    super.key,
    required this.text,
    required this.createdAt,
    required this.fn,
    required this.moodId,
  });

  @override
  State<MoodTile> createState() => _MoodTileState();
}

class _MoodTileState extends State<MoodTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final Animation<Offset> _shrinkAnimation = Tween(
    begin: Offset.zero,
    end: const Offset(-2, 0),
  ).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ),
  );

  @override
  void initState() {
    super.initState();
    if (widget.moodId == "00000000") _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => widget.fn(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SlideTransition(
            position: _shrinkAnimation,
            child: Container(
              // height: 150,
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size16,
                vertical: Sizes.size10,
              ),
              // alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.moodId == "00000000"
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(
                  Sizes.size18,
                ),
                border: Border.all(
                  width: Sizes.size2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black, // 그림자 색상 및 투명도
                    spreadRadius: 1, // 그림자의 범위를 조절
                    blurRadius: 0, // 블러 정도
                    offset: Offset(0, 2), // 우측과 하단으로 그림자의 위치 조절
                  ),
                ],
              ),
              child: Text(
                widget.text,
                style: const TextStyle(
                  fontSize: Sizes.size16,
                ),
              ),
            ),
          ),
          Gaps.v10,
          Text(
            diffTimeString(dateTime: widget.createdAt, isLong: true),
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Gaps.v20,
        ],
      ),
    );
  }
}
