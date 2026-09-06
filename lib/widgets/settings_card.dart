import 'package:habits_together/bloc/theme/theme_cubit.dart';
import 'package:habits_together/theme/theme.dart' as theme;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: themeMode == ThemeMode.light
              ? Colors.white
              : const Color(0xFF292929),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
            ),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return CupertinoSwitch(value: value, onChanged: onChanged);
              },
            ),
          ],
        ),
      ),
    );
  }
}
