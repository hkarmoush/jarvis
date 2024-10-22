import 'package:jarvis/domain/repositories/image_repository.dart';

class CacheImageUseCase {
  final ImageRepository _repository;

  CacheImageUseCase(this._repository);

  Future<void> execute(String url, dynamic imageData) {
    return _repository.cacheImage(url, imageData);
  }
}
