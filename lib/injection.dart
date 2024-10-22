import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis/data/repositories/logger_repository_impl.dart';
import 'package:jarvis/data/repositories/theme_repository_impl.dart';
import 'package:jarvis/domain/repositories/logger_repository.dart';
import 'package:jarvis/domain/repositories/theme_repository.dart';
import 'package:jarvis/domain/usecases/get_theme_mode_usecase.dart';
import 'package:jarvis/domain/usecases/set_theme_mode_usecase.dart';
import 'package:jarvis/infra/network/circuit_breaker/circuit_breaker.dart';
import 'package:jarvis/infra/network/network_manager.dart';
import 'package:jarvis/infra/network/retry/retry_strategy.dart';
import 'package:jarvis/presentation/managers/theme_manager.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  /// Theme deps
  getIt.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl());
  getIt.registerLazySingleton(() => GetThemeModeUseCase(getIt()));
  getIt.registerLazySingleton(() => SetThemeModeUseCase(getIt()));
  getIt.registerLazySingleton(() => ThemeManager(getIt(), getIt()));

  /// Logger deps
  getIt.registerLazySingleton<LoggerRepository>(() => LoggerRepositoryImpl());
}

@module
abstract class NetworkModule {
  @LazySingleton(as: NetworkManager)
  NetworkManager<T> provideNetworkManager<T>(LoggerRepository logger) =>
      NetworkManagerImpl(logger);

  @LazySingleton()
  RetryStrategy provideRetryStrategy() => SimpleRetryStrategy();

  @LazySingleton()
  CircuitBreaker provideCircuitBreaker() {
    return CircuitBreaker(
      failureThreshold: 3,
      timeout: const Duration(seconds: 30),
    );
  }

  @LazySingleton()
  AuthenticatedNetworkManager<T> provideAuthenticatedManager<T>(
    NetworkManager<T> networkManager,
    @Named('authToken') String authToken,
  ) {
    return AuthenticatedNetworkManager<T>(
      networkManager,
      authToken,
    );
  }

  @LazySingleton()
  CachedNetworkManager<T> provideCachedManager<T>(
    AuthenticatedNetworkManager<T> authManager,
  ) {
    return CachedNetworkManager<T>(authManager);
  }

  @LazySingleton()
  RetryNetworkManager<T> provideRetryManager<T>(
    CachedNetworkManager<T> cachedManager,
    RetryStrategy retryStrategy,
  ) {
    return RetryNetworkManager<T>(
      cachedManager,
      maxAttempts: 3,
      delay: const Duration(seconds: 1),
    );
  }

  @LazySingleton()
  CircuitBreakerNetworkManager<T> provideCircuitBreakerManager<T>(
    RetryNetworkManager<T> retryManager,
    CircuitBreaker circuitBreaker,
  ) {
    return CircuitBreakerNetworkManager<T>(
      retryManager,
      circuitBreaker,
    );
  }
}
