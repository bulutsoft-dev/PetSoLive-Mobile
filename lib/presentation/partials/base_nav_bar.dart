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
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
      child: Material(
        elevation: 16,
        borderRadius: BorderRadius.circular(24),
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.petsoliveBg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: items.map((item) {
              return BottomNavigationBarItem(
                icon: SizedBox(height: 30, width: 30, child: Center(child: IconTheme(data: const IconThemeData(size: 30), child: item.icon))),
                activeIcon: SizedBox(height: 34, width: 34, child: Center(child: IconTheme(data: const IconThemeData(size: 34), child: item.activeIcon ?? item.icon))),
                label: item.label,
                backgroundColor: item.backgroundColor,
                tooltip: item.tooltip,
              );
            }).toList(),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: isDark ? AppColors.darkPrimary : AppColors.petsolivePrimary,
            unselectedItemColor: isDark ? AppColors.bsGray400 : AppColors.bsGray500,
            backgroundColor: Colors.transparent,
            showUnselectedLabels: true,
            elevation: 0,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
} 