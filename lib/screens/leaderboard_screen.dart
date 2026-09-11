import 'package:habits_together/bloc/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardScreen extends StatelessWidget {
  final String? habitId;
  final String? habitName;

  const LeaderboardScreen({super.key, this.habitId, this.habitName});

  // Запрос свежих данных лидерборда
  Future<List<Map<String, dynamic>>> _fetchLeaderboard() async {
    final query = Supabase.instance.client.from('habit_leaderboard').select();

    if (habitId != null) {
      return await query
          .eq('habit_id', habitId!)
          .order('streak', ascending: false);
    }

    return await query.order('streak', ascending: false);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final isDark = themeMode == ThemeMode.dark;

    final titleText = habitName != null && habitName!.isNotEmpty
        ? 'Лидеры $habitName'
        : 'Таблица лидеров';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        backgroundColor: isDark ? const Color(0xff292929) : Colors.white,
      ),
      // Подписываемся на события изменения в логах привычек (Realtime)
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('habit_logs')
            .stream(primaryKey: ['id']),
        builder: (context, realtimeSnapshot) {
          // Каждый раз, когда в habit_logs происходит insert/delete,
          // запускается FutureBuilder для обновления View
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchLeaderboard(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Ошибка: ${snapshot.error}'));
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
                itemBuilder: (context, index) {
                  final member = leaderboard[index];
                  final streak = member['streak'] ?? 0;
                  final userName =
                      member['user_name'] ?? 'Участник ${index + 1}';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF292929) : Colors.white,
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
                          if (index == 0) ...[
                            const Icon(Icons.bolt_rounded, size: 28),
                          ],
                          const Icon(
                            Icons.local_fire_department_rounded,
                            size: 18,
                            color: Colors.orangeAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$streak дн.',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
