import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/gaps.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/sizes.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/view_models/user_profile_view_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/views/login_screen.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/common/widgets/nav_tab.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/views/home_screen.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/views/create_mood_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:go_router/go_router.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  static const String routeName = "mainNavigation";
  static const String routeURL = "/:tab(home|settings)";
  final String tab;

  const MainNavigationScreen({
    super.key,
    this.tab = "home",
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  final PageController _pageController = PageController();

  int _selectedIndex = 0;

  final List<String> _tabs = [
    "home",
    "settings",
  ];

  DateTime? lastTapTime;
  int tapCount = 0;

  @override
  void initState() {
    super.initState();

    // Future.microtask(
    //   () {
    //     setState(() {
    //       _selectedIndex = _tabs.indexOf(widget.tab);
    //       _pageController.animateToPage(
    //         _selectedIndex,
    //         duration: const Duration(milliseconds: 200),
    //         curve: Curves.easeInOut,
    //       );
    //     });
    //   },
    // );
  }

  // void _onTap(int index) {
  //   context.go("/${_tabs[index]}");
  //   setState(() {
  //     _selectedIndex = index;
  //     _pageController.animateToPage(
  //       index,
  //       duration: const Duration(milliseconds: 200),
  //       curve: Curves.easeInOut,
  //     );
  //   });
  // }

  _onLogoutTap() {
    ref.read(authRepo).signOut();
    context.goNamed(LoginScreen.routeName);
  }

  Future<void> _showLogoutBottomsheet() async {
    ref.watch(usersProvider);
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
            "${ref.watch(usersProvider).value?.name}님, 로그아웃 하시겠습니까?",
            style: const TextStyle(
              fontSize: Sizes.size18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: _onLogoutTap,
              child: const Text(
                "로그아웃",
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

    /*  await showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      elevation: 0,
      context: context,
      builder: (context) => const SizedBox(
        height: 100,
        child: Scaffold(
          body: SizedBox(
            height: 100,
            child: Text("Log Out"),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Sizes.size16),
          topRight: Radius.circular(Sizes.size16),
        ),
      ),
    ); */
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _eightTappedToLogout() {
    DateTime now = DateTime.now();
    if (lastTapTime == null || now.difference(lastTapTime!).inSeconds > 1) {
      // 1초가 넘었으면 카운트 초기화
      tapCount = 0;
    }
    lastTapTime = now;
    tapCount++;

    if (tapCount == 8) {
      // 8번 탭하면 실행
      _showLogoutBottomsheet();
      // _onLogoutTap();
      tapCount = 0; // 작업 실행 후 카운트 초기화
    }
    setState(() {});
  }

  void _tapToggleShowBottomTabBar() {
    // ref.read(showBottomTabBarProvider.notifier).update((state) => !state);
  }

  void _showPlanMoodBottomSheet() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      // showDragHandle: true,
      elevation: 0,
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: const CreateMoodScreen(),
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
    print("_selectedIndex @MainNavigation : $_selectedIndex");
    // ref.watch(showBottomTabBarProvider);

    if (mounted &&
        _pageController.hasClients &&
        _selectedIndex != _tabs.indexOf(widget.tab)) {
      _pageController.animateToPage(
        _tabs.indexOf(widget.tab),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
    _selectedIndex = _tabs.indexOf(widget.tab);

    return GestureDetector(
      onTap: _tapToggleShowBottomTabBar,
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onLongPress: _showLogoutBottomsheet,
            child: const Text(
              "Mood Planner",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: _eightTappedToLogout,
              icon: Icon(
                Icons.logout,
                color: Colors.transparent,
                size: Sizes.size20 + tapCount * 3,
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                context.go("/${_tabs[index]}");
              },
              children: const [
                HomeScreen(),
                // PostScreen(),
                // 기타 탭 스크린들...
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: GestureDetector(
          onTap: _showPlanMoodBottomSheet,
          child: Container(
            width: Sizes.size60,
            height: Sizes.size60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: Sizes.size2,
              ),
            ),
            child: const FaIcon(
              FontAwesomeIcons.plus,
              size: Sizes.size36,
            ),
          ),
        ),
      ),
    );
  }
}
