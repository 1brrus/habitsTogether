import 'package:achivment_together/bloc/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text('Таблица лидеров'),
        backgroundColor: themeMode == ThemeMode.light
            ? Colors.white
            : const Color(0xff292929),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(5),
        child: Center(
          child: Text(
            'Таблица лидеров пуста',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
