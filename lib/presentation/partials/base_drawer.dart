import 'package:flutter/material.dart';
import '../themes/colors.dart';

class BaseDrawer extends StatelessWidget {
  final List<Widget> children;
  final Widget? header;

  const BaseDrawer({
    Key? key,
    required this.children,
    this.header,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (header != null) header!,
          ...children,
        ],
      ),
    );
  }
} 