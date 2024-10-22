import 'package:flutter/widgets.dart';

class ImageDisplayConfig {
  final double containerWidth;
  final double containerHeight;
  final bool isFullScreen;
  final double? compressionQuality;
  final bool shouldCrop;
  final BoxFit fit;

  ImageDisplayConfig({
    required this.containerWidth,
    required this.containerHeight,
    this.isFullScreen = false,
    this.compressionQuality = 1.0,
    this.shouldCrop = false,
    this.fit = BoxFit.cover,
  });
}

class ImageConfigurations {
  static ImageDisplayConfig profilePicture(double size) {
    return ImageDisplayConfig(
      containerWidth: size,
      containerHeight: size,
      compressionQuality: 0.8,
      shouldCrop: true, // Circular cropping for profile pictures
      fit: BoxFit.cover,
    );
  }

  static ImageDisplayConfig feedImage(double width, double height) {
    return ImageDisplayConfig(
      containerWidth: width,
      containerHeight: height,
      compressionQuality: 0.9,
      fit: BoxFit.cover,
    );
  }

  static ImageDisplayConfig productImage(double width, double height) {
    return ImageDisplayConfig(
      containerWidth: width,
      containerHeight: height,
      compressionQuality: 0.95, // Higher quality for product images
      fit: BoxFit.contain, // Show the entire product without cropping
    );
  }

  static ImageDisplayConfig bannerImage(double screenWidth) {
    return ImageDisplayConfig(
      containerWidth: screenWidth,
      containerHeight: screenWidth * 0.5, // Banners are typically wider
      isFullScreen: true,
      compressionQuality: 0.85,
    );
  }
}
