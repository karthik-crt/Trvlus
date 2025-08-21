import 'package:flutter/material.dart';

class DotDivider extends StatelessWidget {
  final double dotSize;
  final double spacing;
  final int dotCount;
  final Color color;

  DotDivider(
      {this.dotSize = 4.0,
      this.spacing = 8.0,
      this.dotCount = 20,
      this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        dotCount,
        (index) => Container(
          width: dotSize,
          height: dotSize,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
