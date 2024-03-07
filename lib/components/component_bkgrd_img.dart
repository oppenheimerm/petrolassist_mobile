import 'package:flutter/material.dart';

/// Widget component to set a background image. the [imageUrl] must be int the
/// format: assets/images/someImage.jpg. the [fit] parameter is of type
/// [BoxFit].
class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    super.key,
    required this.imageUrl,
    required this.fit,
  });

  final String imageUrl;
  final BoxFit fit;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset(imageUrl, fit: fit),
    );
  }
}
