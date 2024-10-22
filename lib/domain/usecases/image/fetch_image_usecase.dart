import 'package:jarvis/domain/entities/image_entity.dart';
import 'package:jarvis/domain/repositories/image_repository.dart';

class FetchImageUseCase {
  final ImageRepository _repository;

  FetchImageUseCase(this._repository);

  Future<ImageEntity> execute(String url) {
    return _repository.fetchImage(url);
  }
}
