import 'dart:typed_data';

import 'package:image/image.dart' as img;

abstract class ImageOptimizer {
  Future<dynamic> optimize({
    required Uint8List imageData,
    int? targetWidth,
    int? targetHeight,
    double? quality,
  });
}

class ImageOptimizerImpl implements ImageOptimizer {
  @override
  Future<Uint8List> optimize({
    required Uint8List imageData,
    int? targetWidth,
    int? targetHeight,
    double? quality,
  }) async {
    // Decode the image
    img.Image? image = img.decodeImage(imageData);

    if (image == null) {
      throw Exception('Failed to decode image.');
    }

    if (targetWidth != null && targetHeight != null) {
      image = img.copyResize(
        image,
        width: targetWidth,
        height: targetHeight,
      );
    }

    if (quality != null && quality < 1.0) {
      return Uint8List.fromList(
          img.encodeJpg(image, quality: (quality * 100).toInt()));
    }

    return Uint8List.fromList(img.encodePng(image));
  }
}
