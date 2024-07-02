import 'dart:ui';

import 'package:flutter/material.dart';

class BlurImageContainer extends StatelessWidget {
  final String image;
  final Widget child;

  const BlurImageContainer({
    super.key,
    required this.image,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(1),
                Colors.black54.withOpacity(0.1),
                Colors.black.withOpacity(1),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
