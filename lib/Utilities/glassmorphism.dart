import 'package:flutter/material.dart';
import 'dart:ui';

class GlassMorphism extends StatelessWidget {
  final double blur;
  final double opacity;
  final Widget child;
  final double? width;
  final double? height;
  final double cornerRadius;
  final double borderThickness;
  const GlassMorphism({
    Key? key,
    required this.blur,
    required this.opacity,
    required this.child,
    required this.cornerRadius,
    this.width,
    this.height,
    required this.borderThickness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cornerRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.all(
              Radius.circular(cornerRadius),
            ),
            border: Border.all(
              width: borderThickness,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
