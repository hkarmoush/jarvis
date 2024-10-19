import 'package:jarvis/domain/entities/theme_mode_entity.dart';
import 'package:jarvis/domain/repositories/theme_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  static const themeKey = 'theme_mode';

  @override
  Future<void> saveThemeMode(ThemeModeEntity themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeKey, themeMode.toString());
  }

  @override
  Future<ThemeModeEntity> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(themeKey);
    switch (themeString) {
      case 'ThemeModeEntity.light':
        return ThemeModeEntity.light;
      case 'ThemeModeEntity.dark':
        return ThemeModeEntity.dark;
      case 'ThemeModeEntity.custom':
        return ThemeModeEntity.custom;
      default:
        return ThemeModeEntity.system;
    }
  }
}
