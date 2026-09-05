import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const darkThemePrimary = Color(0xffc4c4c4);
const lightThemePrimary = Color(0xff0008ff);

/*


Светлая тема


*/

final lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: lightThemePrimary,
  textTheme: textTheme,
  scaffoldBackgroundColor: const Color(0xfff1f1f1),
  dividerTheme: DividerThemeData(color: Colors.grey.withAlpha(100)),

  // 1. Цветовая схема карточек
  cardTheme: const CardThemeData(
    color: Colors.white, // Чистый белый фон карточки
    surfaceTintColor: Colors.transparent,
    elevation: 0,
  ),

  // 2. Цветовая схема Switch
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.all(Colors.white),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xff34c759); // Зелёный при включении (iOS style)
      }
      return Colors.grey[300]; // Серый при выключении
    }),
    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  ),

  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    foregroundColor: lightThemePrimary,
    titleTextStyle: TextStyle(
      color: lightThemePrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  colorScheme: ColorScheme.fromSeed(
    seedColor: lightThemePrimary, // 👈 Исправлена переменная!
    brightness: Brightness.light,
  ),
);

/*


Тёмная тема


*/
final darkTheme = ThemeData(
  useMaterial3: true,
  primaryColor: darkThemePrimary,
  textTheme: textTheme,
  scaffoldBackgroundColor: Color(0xff1f1f1f),

  // 1. Цветовая схема карточек для тёмной темы
  cardTheme: CardThemeData(
    color: const Color(0xFF292929), // Тёмно-серый фон карточки
    surfaceTintColor: Colors.transparent,
    elevation: 0,
  ),

  // 2. Цветовая схема Switch для тёмной темы
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.all(Colors.white),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xff34c759); // Ярко-зеленый на тёмной теме
      }
      return Colors.grey[800];
    }),
    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  ),

  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    foregroundColor: darkThemePrimary,
    titleTextStyle: TextStyle(
      color: darkThemePrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  colorScheme: ColorScheme.fromSeed(
    seedColor: darkThemePrimary,
    brightness: Brightness.dark,
  ),
);

final textTheme = const TextTheme(
  titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
);
