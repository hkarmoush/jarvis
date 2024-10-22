import 'dart:typed_data';

class ImageEntity {
  final String url;
  final String? optimizedUrl;
  final Uint8List imageData;

  ImageEntity({
    required this.url,
    this.optimizedUrl,
    required this.imageData,
  });
}
