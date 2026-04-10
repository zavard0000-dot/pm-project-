import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = null,
    this.width = double.infinity,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: const Color.fromARGB(255, 235, 236, 236),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
