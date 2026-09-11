import 'package:habits_together/bloc/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardScreen extends StatelessWidget {
  final String? habitId;

  const LeaderboardScreen({super.key, this.habitId});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final isDark = themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Таблица лидеров'),
        backgroundColor: isDark ? const Color(0xff292929) : Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: habitId != null
            ? Supabase.instance.client
                  .from('habit_leaderboard')
                  .select()
                  .eq('habit_id', habitId!)
                  .order('streak', ascending: false)
            : Supabase.instance.client
                  .from('habit_leaderboard')
                  .select()
                  .order('streak', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка ${snapshot.error}'));
          }
          final leaderboard = snapshot.data ?? [];

          if (leaderboard.isEmpty) {
            return const Center(
              child: Text(
                'Таблица лидеров пуста',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: leaderboard.length,
            itemBuilder: ((context, index) {
              final member = leaderboard[index];
              final streak = member['streak'] ?? 0;
              final userName = member['user_name'] ?? 'Участник ${index + 1}';

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xff292929) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: index == 0
                        ? Colors.amber.shade600
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: index == 0
                        ? Colors.amber
                        : (isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: index == 0 ? Colors.black : null,
                      ),
                    ),
                  ),
                  title: Text(
                    userName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (index == 0) ...[const Icon(Icons.bolt_rounded)],
                      const Icon(
                        Icons.local_fire_department_rounded,
                        size: 18,
                        color: Colors.orangeAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$streak дн',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
