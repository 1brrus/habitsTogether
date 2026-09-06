import 'package:habits_together/bloc/theme/theme_cubit.dart';
import 'package:habits_together/widgets/logout_button.dart';
import 'package:habits_together/widgets/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: themeMode == ThemeMode.light
            ? Colors.white
            : const Color(0xFF292929),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: ListView(
          children: [
            SettingsCard(
              title: 'Темная тема',
              value: themeMode == ThemeMode.dark,
              onChanged: (value) {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
            SettingsCard(
              title: 'Присылать уведомления',
              value: false,
              onChanged: (_) {},
            ),
            SettingsCard(title: 'Чё-то еще', value: false, onChanged: (_) {}),
            LogOutButton(),
          ],
        ),
      ),
    );
  }
}
