import 'package:flutter/material.dart';
import 'package:pherico_admin_app/config/my_color.dart';

class GradientElevatedButtonWithIndicator extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Widget child;
  final VoidCallback onPressed;
  const GradientElevatedButtonWithIndicator(
      {this.radius = 50,
      this.width = 120,
      this.height = 40,
      required this.child,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: const EdgeInsets.all(0.0),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        child: Container(
          constraints: BoxConstraints(minHeight: height, minWidth: width),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
