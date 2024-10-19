import 'package:flutter/material.dart';
import 'package:jarvis/domain/entities/theme_mode_entity.dart';
import 'package:jarvis/domain/usecases/get_theme_mode_usecase.dart';
import 'package:jarvis/domain/usecases/set_theme_mode_usecase.dart';

class ThemeManager extends ChangeNotifier {
  final GetThemeModeUseCase getThemeModeUseCase;
  final SetThemeModeUseCase setThemeModeUseCase;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeManager(this.getThemeModeUseCase, this.setThemeModeUseCase);

  ThemeMode get themeMode => _themeMode;

  Future<void> loadThemeMode() async {
    final themeModeEntity = await getThemeModeUseCase.call();
    _themeMode = _mapThemeModeEntityToFlutter(themeModeEntity);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeModeEntity themeModeEntity) async {
    _themeMode = _mapThemeModeEntityToFlutter(themeModeEntity);
    await setThemeModeUseCase.call(themeModeEntity);
    notifyListeners();
  }

  ThemeMode _mapThemeModeEntityToFlutter(ThemeModeEntity themeModeEntity) {
    switch (themeModeEntity) {
      case ThemeModeEntity.light:
        return ThemeMode.light;
      case ThemeModeEntity.dark:
        return ThemeMode.dark;
      case ThemeModeEntity.custom:
        return ThemeMode.light; // For simplicity, map custom to light.
      default:
        return ThemeMode.system;
    }
  }
}
