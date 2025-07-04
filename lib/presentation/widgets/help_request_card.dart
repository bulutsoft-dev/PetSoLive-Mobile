import 'package:flutter/material.dart';
import '../../data/models/help_request_dto.dart';
import 'package:intl/intl.dart';
import '../themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class HelpRequestCard extends StatelessWidget {
  final HelpRequestDto request;
  final VoidCallback? onTap;

  const HelpRequestCard({required this.request, this.onTap, Key? key}) : super(key: key);

  Color _emergencyColor(String level, BuildContext context) {
    switch (level.toLowerCase()) {
      case 'high':
        return Theme.of(context).brightness == Brightness.dark
            ? AppColors.petsoliveDanger.withOpacity(0.85)
            : AppColors.petsoliveDanger;
      case 'medium':
        return Theme.of(context).brightness == Brightness.dark
            ? AppColors.petsoliveWarning.withOpacity(0.85)
            : AppColors.petsoliveWarning;
      case 'low':
        return Theme.of(context).brightness == Brightness.dark
            ? AppColors.petsoliveSuccess.withOpacity(0.85)
            : AppColors.petsoliveSuccess;
      default:
        return Theme.of(context).colorScheme.primary.withOpacity(0.7);
    }
  }

  String _localizedEmergencyLevel(BuildContext context) {
    switch (request.emergencyLevel.toLowerCase()) {
      case 'high':
        return 'help_requests.emergency_high'.tr();
      case 'medium':
        return 'help_requests.emergency_medium'.tr();
      case 'low':
        return 'help_requests.emergency_low'.tr();
      default:
        return request.emergencyLevel;
    }
  }

  String _localizedStatus(BuildContext context) {
    switch (request.status.toLowerCase()) {
      case 'open':
        return 'help_requests.status_open'.tr();
      case 'closed':
        return 'help_requests.status_closed'.tr();
      default:
        return request.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final emergencyColor = _emergencyColor(request.emergencyLevel, context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      shadowColor: emergencyColor.withOpacity(0.18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Stack(
          children: [
            // Emergency colored stripe
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 7,
                decoration: BoxDecoration(
                  color: emergencyColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar or placeholder
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colorScheme.surface,
                    backgroundImage: (request.imageUrl != null && request.imageUrl!.isNotEmpty)
                        ? NetworkImage(request.imageUrl!)
                        : null,
                    child: (request.imageUrl == null || request.imageUrl!.isEmpty)
                        ? Icon(Icons.volunteer_activism, color: emergencyColor, size: 32)
                        : null,
                  ),
                  const SizedBox(width: 14),
                  // Main info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Chip(
                                label: Text(_localizedEmergencyLevel(context), overflow: TextOverflow.ellipsis),
                                backgroundColor: emergencyColor.withOpacity(0.13),
                                labelStyle: theme.textTheme.labelMedium?.copyWith(
                                  color: emergencyColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                side: BorderSide(color: emergencyColor.withOpacity(0.45)),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Chip(
                                label: Text(_localizedStatus(context), overflow: TextOverflow.ellipsis),
                                backgroundColor: request.status.toLowerCase() == 'open'
                                    ? AppColors.petsoliveSuccess.withOpacity(0.13)
                                    : AppColors.bsGray300.withOpacity(0.18),
                                labelStyle: theme.textTheme.labelMedium?.copyWith(
                                  color: request.status.toLowerCase() == 'open'
                                      ? AppColors.petsoliveSuccess
                                      : AppColors.bsGray700,
                                  fontWeight: FontWeight.w600,
                                ),
                                side: BorderSide(
                                  color: (request.status.toLowerCase() == 'open'
                                      ? AppColors.petsoliveSuccess
                                      : AppColors.bsGray400).withOpacity(0.45),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          request.title,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.description,
                          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.85)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: colorScheme.primary.withOpacity(0.7)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                request.location,
                                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.person, size: 15, color: colorScheme.secondary.withOpacity(0.7)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                request.userName,
                                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.calendar_today, size: 14, color: colorScheme.secondary.withOpacity(0.7)),
                            const SizedBox(width: 2),
                            Text(
                              DateFormat('dd.MM.yyyy').format(request.createdAt),
                              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 