import 'package:habits_together/bloc/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailedHabitScreen extends StatefulWidget {
  const DetailedHabitScreen({super.key});

  @override
  State<DetailedHabitScreen> createState() => _DetailedHabitScreenState();
}

class _DetailedHabitScreenState extends State<DetailedHabitScreen> {
  final _nameController = TextEditingController();

  final _nameFocusNode = FocusNode();

  bool _isNameFocused = false;

  @override
  void initState() {
    super.initState();

    _nameFocusNode.addListener(() {
      setState(() {
        _isNameFocused = _nameFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Привычка'),
        backgroundColor: themeMode == ThemeMode.light
            ? Colors.white
            : Color(0xff292929),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isNameFocused
                    ? [
                        BoxShadow(
                          color: primaryColor.withAlpha(100),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: TextField(
                focusNode: _nameFocusNode,
                controller: _nameController,
                cursorColor: primaryColor,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: primaryColor, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: primaryColor, width: 2.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
