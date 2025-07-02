import 'package:flutter/material.dart';
import '../themes/colors.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;

  const BaseAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? (isDark ? AppColors.darkPrimary : AppColors.primary),
      actions: actions,
      leading: leading,
      elevation: 2,
      iconTheme: IconThemeData(
        color: isDark ? AppColors.darkOnPrimary : AppColors.onPrimary,
      ),
      titleTextStyle: TextStyle(
        color: isDark ? AppColors.darkOnPrimary : AppColors.onPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 