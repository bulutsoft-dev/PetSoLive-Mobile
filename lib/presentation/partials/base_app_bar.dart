import 'package:flutter/material.dart';
import '../themes/colors.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final bool showLogo;

  const BaseAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.showLogo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      title: showLogo
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 32,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          : Text(
              title,
              overflow: TextOverflow.ellipsis,
            ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? (isDark ? AppColors.darkSurface : AppColors.petsoliveBg),
      actions: actions,
      leading: leading,
      elevation: 2,
      iconTheme: IconThemeData(
        color: isDark ? AppColors.darkOnPrimary : AppColors.petsolivePrimary,
      ),
      titleTextStyle: TextStyle(
        color: isDark ? AppColors.darkOnPrimary : AppColors.petsolivePrimary,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 