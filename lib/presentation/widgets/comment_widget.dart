import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final String userName;
  final String date;
  final String comment;

  const CommentWidget({
    Key? key,
    required this.userName,
    required this.date,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: colorScheme.primary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, size: 18, color: colorScheme.primary.withOpacity(0.7)),
              const SizedBox(width: 6),
              Text(
                userName,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Icon(Icons.calendar_today, size: 15, color: colorScheme.secondary.withOpacity(0.7)),
              const SizedBox(width: 4),
              Text(
                date,
                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            comment,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
} 