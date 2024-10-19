import 'package:jarvis/domain/entities/theme_mode_entity.dart';
import 'package:jarvis/domain/repositories/theme_repository.dart';

class GetThemeModeUseCase {
  final ThemeRepository repository;

  GetThemeModeUseCase(this.repository);

  Future<ThemeModeEntity> call() async {
    return await repository.getThemeMode();
  }
}
