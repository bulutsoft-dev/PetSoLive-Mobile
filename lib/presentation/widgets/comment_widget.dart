import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CommentWidget extends StatelessWidget {
  final String userName;
  final String date;
  final String comment;
  final bool isVeterinarian;
  final bool isOwnComment;
  final bool isOwnerOfRequest;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CommentWidget({
    Key? key,
    required this.userName,
    required this.date,
    required this.comment,
    this.isVeterinarian = false,
    this.isOwnComment = false,
    this.isOwnerOfRequest = false,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    Color borderColor = colorScheme.primary.withOpacity(0.08);
    Color bgColor = colorScheme.surface;
    Color nameColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    FontWeight nameWeight = FontWeight.bold;
    // Tüm kartların arka planı aynı olsun
    bgColor = colorScheme.surface;
    // Kullanıcı adı rengi ve border: öncelik veteriner > ilan sahibi > normal
    if (isVeterinarian) {
      borderColor = colorScheme.secondary;
      nameColor = colorScheme.secondary;
    } else if (isOwnerOfRequest) {
      borderColor = colorScheme.primary.withOpacity(0.18);
      nameColor = colorScheme.primary;
    } else {
      borderColor = colorScheme.primary.withOpacity(0.08);
      nameColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    }
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: borderColor,
              width: (isVeterinarian || isOwnerOfRequest) ? 1.7 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.person, size: 18, color: colorScheme.primary.withOpacity(0.7)),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      userName,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: nameWeight, color: nameColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.calendar_today, size: 15, color: colorScheme.secondary.withOpacity(0.7)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      date,
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
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
        ),
        if (isOwnComment)
          Positioned(
            right: 2,
            top: 2,
            child: Row(
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
          ),
        if (isVeterinarian)
          Positioned(
            right: 10,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.13),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.secondary, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.medical_services, size: 14, color: colorScheme.secondary),
                  const SizedBox(width: 3),
                  Text(
                    'comment.veterinarian_badge'.tr(),
                    style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.secondary, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
} 