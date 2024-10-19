import 'package:jarvis/domain/entities/theme_mode_entity.dart';

abstract class ThemeRepository {
  Future<void> saveThemeMode(ThemeModeEntity themeMode);
  Future<ThemeModeEntity> getThemeMode();
}
