import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final String userName;
  final String date;
  final String comment;
  final bool isVeterinarian;
  final bool isOwnComment;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CommentWidget({
    Key? key,
    required this.userName,
    required this.date,
    required this.comment,
    this.isVeterinarian = false,
    this.isOwnComment = false,
    this.onEdit,
    this.onDelete,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.person, size: 18, color: colorScheme.primary.withOpacity(0.7)),
                    const SizedBox(width: 6),
                    Text(
                      userName,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (isVeterinarian) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colorScheme.secondary, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.medical_services, size: 14, color: colorScheme.secondary),
                            const SizedBox(width: 3),
                            Text('Veteriner', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.secondary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(width: 10),
                    Icon(Icons.calendar_today, size: 15, color: colorScheme.secondary.withOpacity(0.7)),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
              if (isOwnComment)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 28,
                      width: 28,
                      child: IconButton(
                        icon: Icon(Icons.edit, size: 16, color: colorScheme.primary),
                        tooltip: 'Düzenle',
                        onPressed: onEdit,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(width: 2),
                    SizedBox(
                      height: 28,
                      width: 28,
                      child: IconButton(
                        icon: Icon(Icons.delete, size: 16, color: Colors.red),
                        tooltip: 'Sil',
                        onPressed: onDelete,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
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