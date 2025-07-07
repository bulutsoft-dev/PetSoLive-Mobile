import 'package:flutter/material.dart';
import '../themes/colors.dart';
import 'dart:ui';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16, top: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: (isDark ? colorScheme.surface : colorScheme.background).withOpacity(0.85),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 0; i < items.length; i++)
                      _NavBarItem(
                        item: items[i],
                        selected: i == currentIndex,
                        onTap: () => onTap(i),
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final BottomNavigationBarItem item;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final bool isDark;

  const _NavBarItem({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.colorScheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = isDark ? colorScheme.primary : colorScheme.primary;
    final unselectedColor = isDark ? colorScheme.onSurface.withOpacity(0.6) : colorScheme.onSurface.withOpacity(0.6);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          padding: EdgeInsets.symmetric(horizontal: selected ? 16 : 0, vertical: 6),
          decoration: selected
              ? BoxDecoration(
                  color: selectedColor.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(16),
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(
                  color: selected ? selectedColor : unselectedColor,
                  size: selected ? 30 : 26,
                ),
                child: selected ? (item.activeIcon ?? item.icon) : item.icon,
              ),
              if (selected && item.label != null && item.label!.isNotEmpty) ...[
                const SizedBox(width: 8),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    color: selectedColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  child: Text(item.label!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 