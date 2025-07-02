import 'package:flutter/material.dart';
import '../themes/colors.dart';

class BaseNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const BaseNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: isDark ? AppColors.darkPrimary : AppColors.primary,
      unselectedItemColor: Colors.grey,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      showUnselectedLabels: true,
      elevation: 8,
    );
  }
} 