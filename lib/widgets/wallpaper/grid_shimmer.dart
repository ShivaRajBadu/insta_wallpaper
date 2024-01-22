import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomImageShimmer extends StatelessWidget {
  const CustomImageShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xffd62976).withOpacity(0.8),
      highlightColor: const Color(0xffd62976).withOpacity(0.7),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.0,
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          return Container(
            width: 200.0,
            height: 100.0,
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
