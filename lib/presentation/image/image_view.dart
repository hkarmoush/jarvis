import 'package:flutter/material.dart';
import 'package:jarvis/presentation/image/image_display_config.dart';
import 'package:jarvis/presentation/image/image_view_model.dart';
import 'package:jarvis/domain/entities/image_entity.dart';

class ImageView extends StatelessWidget {
  final ImageViewModel _viewModel;
  final String imageUrl;
  final ImageDisplayConfig displayConfig;

  const ImageView({
    required ImageViewModel viewModel,
    required this.imageUrl,
    required this.displayConfig,
    Key? key,
  })  : _viewModel = viewModel,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageEntity>(
      future: _viewModel.loadImage(imageUrl, displayConfig, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return Image.memory(
            snapshot.data!.imageData,
            fit: displayConfig.fit,
            width: displayConfig.containerWidth,
            height: displayConfig.containerHeight,
          );
        } else {
          return const Text('Failed to load image');
        }
      },
    );
  }
}
