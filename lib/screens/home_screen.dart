import 'package:achivment_together/bloc/theme/theme_cubit.dart';
import 'package:achivment_together/screens/create_habit_screen.dart';
import 'package:achivment_together/screens/detailed_habit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/habit_card.dart';
import '../widgets/add_habits_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _habitsFuture;

  @override
  void initState() {
    super.initState();
    _fetchHabits();
  }

  void _fetchHabits() {
    setState(() {
      _habitsFuture = Supabase.instance.client
          .from('habits')
          .select()
          .order('created_at', ascending: true);
    });
  }

  void _openCreateHabitModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const CreateHabitScreen(),
    );

    _fetchHabits();
  }

  Future<void> _deleteHabit(String habitId) async {
    final confirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Удалить привычку?'),
        content: const Text('Вы уверены, что хотите удалить эту привычку?'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await Supabase.instance.client.from('habits').delete().eq('id', habitId);

      _fetchHabits();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Меню привычек'),
        backgroundColor: themeMode == ThemeMode.light
            ? Colors.white
            : const Color(0xFF292929),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _habitsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Ошибка загрузки: ${snapshot.error}'),
                    );
                  }

                  final habits = snapshot.data ?? [];

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                    itemCount: habits.length + 1,
                    itemBuilder: (context, index) {
                      if (index == habits.length) {
                        return AddHabitsCard(
                          onTap: () {
                            _openCreateHabitModal();
                          },
                        );
                      }

                      final habit = habits[index];

                      return HabitCard(
                        habitName: habit['title'] ?? '',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => const DetailedHabitScreen(),
                            ),
                          );
                        },
                        onLongPress: () {
                          _deleteHabit(habit['id']);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
