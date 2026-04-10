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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? AppColors.darkInputBorder
              : const Color.fromARGB(255, 235, 236, 236),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
