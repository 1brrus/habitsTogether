import 'package:habits_together/bloc/theme/theme_cubit.dart';
import 'package:habits_together/screens/create_habit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

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
    final userId = Supabase.instance.client.auth.currentUser?.id;
    setState(() {
      _habitsFuture = Supabase.instance.client
          .from('habits')
          .select('*, habit_logs(completed_at), habit_members!inner(user_id)')
          .eq('habit_members.user_id', userId!)
          .order('created_at', ascending: true);
    });
  }

  Future<void> _toggleHabit(String habitId, bool isCompleted) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final todayStr = DateTime.now().toIso8601String().split('T')[0];

    try {
      if (isCompleted) {
        await Supabase.instance.client.from('habit_logs').upsert({
          'habit_id': habitId,
          'user_id': userId,
          'completed_at': todayStr,
        }, onConflict: 'habit_id, completed_at');
      } else {
        await Supabase.instance.client
            .from('habit_logs')
            .delete()
            .eq('habit_id', habitId)
            .eq('completed_at', todayStr);
      }
      _fetchHabits();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка обновления: $e')));
      }
    }
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
            child: const Text(
              'Отмена',
              style: TextStyle(
                color: CupertinoColors.systemBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
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

                      final logs = habit['habit_logs'] as List<dynamic>? ?? [];
                      final completedDates = logs
                          .map((log) => log['completed_at'].toString())
                          .toSet();

                      return HabitCard(
                        habitId: habit['id'],
                        habitName: habit['title'] ?? '',
                        completedDates: completedDates,
                        onToggle: (bool isCompleted) {
                          _toggleHabit(habit['id'], isCompleted);
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
