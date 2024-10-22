import 'package:jarvis/domain/entities/image_entity.dart';

abstract class ImageRepository {
  Future<ImageEntity> fetchImage(String url);
  Future<void> cacheImage(String url, dynamic imageData);
}
