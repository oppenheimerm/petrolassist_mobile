import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({super.key, this.width = double.infinity, required this.height, this.shapeBorder = const RoundedRectangleBorder()});
  const ShimmerWidget.circular({super.key, required this.width, required this.height, this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) {
    return  Shimmer.fromColors(
      baseColor: Colors.grey[400]!/* darker colour */,
      // Note the use of the "!" is this is nullable, but
      //  we know here it can't be null
      highlightColor: Colors.grey[300]!/* lighter colour */,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[400]!,
          shape: shapeBorder
        ),
      ),
    );
  }
}

