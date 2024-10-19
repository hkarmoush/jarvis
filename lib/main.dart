import 'dart:io';

import 'package:flutter/cupertino.dart';
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
      create: (_) => getIt<ThemeManager>()..load(),
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, _) {
          if (Platform.isIOS) {
            return CupertinoApp(
              title: 'Flutter Clean Architecture Theme',
              theme: themeManager.themeMode == ThemeMode.dark
                  ? AppTheme.darkCupertinoTheme
                  : AppTheme.lightCupertinoTheme,
              home: HomePage(),
            );
          } else {
            return MaterialApp(
              title: 'Flutter Clean Architecture Theme',
              theme: AppTheme.lightMaterialTheme,
              darkTheme: AppTheme.darkMaterialTheme,
              themeMode: themeManager.themeMode,
              home: HomePage(),
            );
          }
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

    return Platform.isIOS
        ? _buildCupertinoPage(themeManager)
        : _buildMaterialPage(themeManager);
  }

  // Material Design for Android
  Widget _buildMaterialPage(ThemeManager themeManager) {
    return Scaffold(
      appBar: AppBar(title: Text('Theme Switcher')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => themeManager.set(ThemeModeEntity.light),
            child: Text('Switch to Light Theme'),
          ),
          ElevatedButton(
            onPressed: () => themeManager.set(ThemeModeEntity.dark),
            child: Text('Switch to Dark Theme'),
          ),
          ElevatedButton(
            onPressed: () => themeManager.set(ThemeModeEntity.system),
            child: Text('Follow System Theme'),
          ),
        ],
      ),
    );
  }

  // Cupertino Design for iOS
  Widget _buildCupertinoPage(ThemeManager themeManager) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Theme Switcher'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
              onPressed: () => themeManager.set(ThemeModeEntity.light),
              child: Text('Switch to Light Theme'),
            ),
            CupertinoButton(
              onPressed: () => themeManager.set(ThemeModeEntity.dark),
              child: Text('Switch to Dark Theme'),
            ),
            CupertinoButton(
              onPressed: () => themeManager.set(
                ThemeModeEntity.system,
              ),
              child: Text('Follow System Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
