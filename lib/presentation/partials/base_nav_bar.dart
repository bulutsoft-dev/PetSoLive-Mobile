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
    // PetSoLive açık mavisi daha baskın degrade
    final Gradient bgGradient = LinearGradient(
      colors: isDark
          ? [AppColors.darkPrimaryVariant.withOpacity(0.92), AppColors.petsolivePrimary.withOpacity(0.18)]
          : [AppColors.petsolivePrimary.withOpacity(0.85), AppColors.petsoliveBg.withOpacity(0.85)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16, top: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: isDark ? 18 : 12, sigmaY: isDark ? 18 : 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: bgGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.25)
                      : AppColors.petsolivePrimary.withOpacity(0.10),
                  blurRadius: isDark ? 32 : 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 2),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 56,
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
                ],
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
    final pillColor = isDark
        ? colorScheme.primary.withOpacity(0.18)
        : colorScheme.primary.withOpacity(0.13);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          padding: EdgeInsets.symmetric(horizontal: selected ? 18 : 0, vertical: 8),
          decoration: selected
              ? BoxDecoration(
                  color: pillColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: selectedColor.withOpacity(isDark ? 0.18 : 0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(
                  color: selected ? selectedColor : unselectedColor,
                  size: selected ? 32 : 26,
                ),
                child: selected ? (item.activeIcon ?? item.icon) : item.icon,
              ),
              if (selected && item.label != null && item.label!.isNotEmpty) ...[
                const SizedBox(width: 10),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 320),
                  style: TextStyle(
                    color: selectedColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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