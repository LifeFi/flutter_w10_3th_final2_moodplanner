import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/gaps.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/sizes.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/view_models/moods_view_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/moods/views/widgets/mood_tile.dart';
import 'package:flutter_w10_3th_final2_moodplanner/utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String routeName = "home";
  static const String routeURL = "/home";
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final DateTime _today = DateTime.now();
  late DateTime _selectedDate = DateTime(
    _today.year,
    _today.month,
    _today.day,
  );

  void _resetToToday() {
    setState(() {
      _selectedDate = DateTime(
        _today.year,
        _today.month,
        _today.day,
      );
    });
  }

  Future<void> _refresh() async {
    if (ref.read(moodsProvider).isLoading) return;
    await ref.read(moodsProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: _refresh,
      child: ref.watch(moodsProvider).when(
            data: (data) {
              final filteredData = data.where(
                (mood) {
                  final date = mood.startDate.toDate();
                  return date.year == _selectedDate.year &&
                      date.month == _selectedDate.month &&
                      date.day == _selectedDate.day;
                },
              ).toList();
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              setState(() {
                                _selectedDate = _selectedDate.subtract(
                                  const Duration(days: 1),
                                );
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: _resetToToday,
                            child: Text(
                              dateFormat(_selectedDate),
                              style: const TextStyle(
                                fontSize: Sizes.size18,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              setState(() {
                                _selectedDate = _selectedDate.add(
                                  const Duration(days: 1),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final mood = filteredData[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: MoodTile(mood: mood),
                        );
                      },
                      childCount: filteredData.length,
                    ),
                  )
                ],
              );
            },
            error: (error, stackTrace) => Center(
              child: Text("오류 발생: $error"),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
    );
  }
}
