import 'package:jarvis/domain/entities/theme_mode_entity.dart';
import 'package:jarvis/domain/repositories/theme_repository.dart';

class SetThemeModeUseCase {
  final ThemeRepository repository;

  SetThemeModeUseCase(this.repository);

  Future<void> call(ThemeModeEntity themeMode) async {
    await repository.saveThemeMode(themeMode);
  }
}
