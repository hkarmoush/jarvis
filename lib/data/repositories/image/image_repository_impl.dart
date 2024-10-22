import 'package:jarvis/data/data_source/image/local_image_data_source.dart';
import 'package:jarvis/data/data_source/image/remote_image_data_source.dart';
import 'package:jarvis/data/repositories/image/image_optimizer.dart';
import 'package:jarvis/domain/entities/image_entity.dart';
import 'package:jarvis/domain/repositories/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final RemoteImageDataSource _remoteDataSource;
  final LocalImageDataSource _localDataSource;
  final ImageOptimizer _imageOptimizer;

  ImageRepositoryImpl(
      this._remoteDataSource, this._localDataSource, this._imageOptimizer);

  @override
  Future<ImageEntity> fetchImage(String url) async {
    final cachedImage = await _localDataSource.getCachedImage(url);
    if (cachedImage != null) {
      return ImageEntity(url: url, imageData: cachedImage);
    }

    var fetchedImage = await _remoteDataSource.fetchImageFromNetwork(url);
    fetchedImage = await _imageOptimizer.optimize(
      imageData: fetchedImage,
      targetWidth: 800,
      targetHeight: 600,
      quality: 0.8,
    );
    await _localDataSource.cacheImage(url, fetchedImage);

    return ImageEntity(url: url, imageData: fetchedImage);
  }

  @override
  Future<void> cacheImage(String url, dynamic imageData) async {
    await _localDataSource.cacheImage(url, imageData);
  }
}
