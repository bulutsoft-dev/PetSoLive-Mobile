import 'package:flutter/material.dart';

class PetTabBar extends StatelessWidget {
  final TabController controller;
  final List<Tab> tabs;
  const PetTabBar({Key? key, required this.controller, required this.tabs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.background,
      child: TabBar(
        controller: controller,
        tabs: tabs,
        isScrollable: false,
        indicatorColor: colorScheme.primary,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
        labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
} 