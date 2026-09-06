import 'package:habits_together/bloc/navigation/navigation_cubit.dart';
import 'package:habits_together/bloc/theme/theme_cubit.dart';
import 'package:habits_together/screens/auth_screen.dart';
import 'package:habits_together/screens/main_shell_screen.dart';
import 'package:habits_together/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ynrhierpofvsjhfjqbvg.supabase.co',
    publishableKey: 'sb_publishable_3xQt0x7UHRay0Z-jaPWVKg_Q9FxS3VO',
  );
  runApp(const MainApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => NavigationCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            themeMode: themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: StreamBuilder<AuthState>(
              stream: Supabase.instance.client.auth.onAuthStateChange,
              builder: (context, snapshot) {
                final session = Supabase.instance.client.auth.currentSession;

                if (session != null) {
                  return const MainShellScreen();
                }

                return const AuthScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
