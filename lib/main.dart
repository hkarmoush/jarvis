import 'package:flutter/material.dart';
import 'package:jarvis/core/theme/app_theme.dart';
import 'package:jarvis/domain/entities/theme_mode_entity.dart';
import 'package:jarvis/injection.dart';
import 'package:jarvis/presentation/managers/theme_manager.dart';
import 'package:provider/provider.dart';

void main() {
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ThemeManager>()..loadThemeMode(),
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, _) {
          return MaterialApp(
            title: 'Flutter Clean Architecture Theme',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeManager.themeMode,
            home: HomePage(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Theme Switcher')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => themeManager.setThemeMode(ThemeModeEntity.light),
            child: Text('Switch to Light Theme'),
          ),
          ElevatedButton(
            onPressed: () => themeManager.setThemeMode(ThemeModeEntity.dark),
            child: Text('Switch to Dark Theme'),
          ),
          ElevatedButton(
            onPressed: () => themeManager.setThemeMode(ThemeModeEntity.system),
            child: Text('Follow System Theme'),
          ),
        ],
      ),
    );
  }
}
