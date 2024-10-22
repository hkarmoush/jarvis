import 'package:flutter/widgets.dart';
import 'package:jarvis/data/repositories/image/image_optimizer.dart';
import 'package:jarvis/domain/entities/image_entity.dart';
import 'package:jarvis/domain/usecases/image/fetch_image_usecase.dart';
import 'package:jarvis/presentation/image/image_display_config.dart';

class ImageViewModel {
  final FetchImageUseCase _fetchImageUseCase;
  final ImageOptimizer _imageOptimizer;

  ImageViewModel(this._fetchImageUseCase, this._imageOptimizer);

  Future<ImageEntity> loadImage(
    String url,
    ImageDisplayConfig displayConfig,
    BuildContext context,
  ) async {
    var imageEntity = await _fetchImageUseCase.execute(url);

    final adjustedWidth =
        displayConfig.containerWidth * MediaQuery.of(context).devicePixelRatio;
    final adjustedHeight =
        displayConfig.containerHeight * MediaQuery.of(context).devicePixelRatio;

    final optimizedImage = await _imageOptimizer.optimize(
      imageData: imageEntity.imageData,
      targetWidth: adjustedWidth.toInt(),
      targetHeight: adjustedHeight.toInt(),
      quality: displayConfig.compressionQuality,
    );

    return ImageEntity(url: imageEntity.url, imageData: optimizedImage);
  }
}
