import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/sizes.dart';

class BigButton extends StatelessWidget {
  final String text;
  final Function fn;
  final Color color;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool enabled;

  const BigButton({
    super.key,
    required this.text,
    required this.fn,
    required this.color,
    this.width,
    this.height,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: enabled || isLoading ? () => fn() : () {},
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: width ?? double.maxFinite,
            height: height ?? Sizes.size48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Sizes.size24,
              ),
              color:
                  enabled && !isLoading ? color : Colors.white.withOpacity(0.9),
              border: Border.all(
                width: Sizes.size2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey, // 그림자 색상 및 투명도
                  spreadRadius: 1, // 그림자의 범위를 조절
                  blurRadius: 0, // 블러 정도
                  offset: Offset(3, 3), // 우측과 하단으로 그림자의 위치 조절
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: Sizes.size18,
                  ),
                ),
                if (isLoading)
                  const Positioned(
                    left: -Sizes.size40,
                    bottom: Sizes.size3,
                    child: CircularProgressIndicator.adaptive(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
