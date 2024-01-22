import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class ShimmerImage extends StatelessWidget {
  final String imageUrl;

  const ShimmerImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return FancyShimmerImage(
      boxFit: BoxFit.cover,
      shimmerBaseColor: const Color(0xffd62976).withOpacity(0.8),
      shimmerHighlightColor: const Color(0xffd62976).withOpacity(0.7),
      imageUrl: imageUrl,
    );
  }
}
