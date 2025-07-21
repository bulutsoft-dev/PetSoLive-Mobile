import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PetSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterPressed;
  final bool isDark;
  const PetSearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onFilterPressed,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.background,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'pets.search_placeholder'.tr(),
                prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDark ? colorScheme.surface : colorScheme.background,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.filter_list, color: colorScheme.primary),
            onPressed: onFilterPressed,
            tooltip: 'Filtrele',
          ),
        ],
      ),
    );
  }
} 