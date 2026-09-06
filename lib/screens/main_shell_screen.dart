import 'package:habits_together/screens/leaderboard_screen.dart';
import 'package:habits_together/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/navigation/navigation_cubit.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  // Список всех экранов нижней навигации
  final List<Widget> _screens = const [
    HomeScreen(),
    LeaderboardScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Получаем текущий индекс из Cubit
    final currentIndex = context.watch<NavigationCubit>().state;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => context.read<NavigationCubit>().selectTab(index),
      ),
    );
  }
}
