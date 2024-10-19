import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis/data/repositories/theme_repository_impl.dart';
import 'package:jarvis/domain/repositories/theme_repository.dart';
import 'package:jarvis/domain/usecases/get_theme_mode_usecase.dart';
import 'package:jarvis/domain/usecases/set_theme_mode_usecase.dart';
import 'package:jarvis/presentation/managers/theme_manager.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl());
  getIt.registerLazySingleton(() => GetThemeModeUseCase(getIt()));
  getIt.registerLazySingleton(() => SetThemeModeUseCase(getIt()));
  getIt.registerLazySingleton(() => ThemeManager(getIt(), getIt()));
}
