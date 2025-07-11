import 'package:flutter/material.dart';
import '../../data/models/help_request_dto.dart';
import 'package:intl/intl.dart';
import '../themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/enums/emergency_level.dart';
import '../../core/enums/help_request_status.dart';
import 'package:http/http.dart' as http;

class HelpRequestCard extends StatelessWidget {
  final HelpRequestDto request;
  final VoidCallback? onTap;

  const HelpRequestCard({required this.request, this.onTap, Key? key}) : super(key: key);

  // --- Enum'dan lokalize label alma fonksiyonları ---
  String _emergencyLabel(EmergencyLevel level) {
    switch (level) {
      case EmergencyLevel.low:
        return 'help_requests.tab_low'.tr();
      case EmergencyLevel.medium:
        return 'help_requests.tab_medium'.tr();
      case EmergencyLevel.high:
        return 'help_requests.tab_high'.tr();
    }
  }

  String _statusLabel(HelpRequestStatus status) {
    switch (status) {
      case HelpRequestStatus.Active:
        return 'help_requests.status_active'.tr();
      case HelpRequestStatus.Passive:
        return 'help_requests.status_passive'.tr();
    }
  }

  // --- Enum'dan renk alma fonksiyonu ---
  Color _emergencyColor(EmergencyLevel level, BuildContext context) {
    switch (level) {
      case EmergencyLevel.high:
        return Theme.of(context).brightness == Brightness.dark
            ? Colors.red[700]!
            : Colors.red;
      case EmergencyLevel.medium:
        return Theme.of(context).brightness == Brightness.dark
            ? Colors.orange[700]!
            : Colors.orange;
      case EmergencyLevel.low:
        return Theme.of(context).brightness == Brightness.dark
            ? Colors.green[700]!
            : Colors.green;
    }
  }

  Widget _emergencyChip(BuildContext context) {
    final color = _emergencyColor(request.emergencyLevel, context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Chip(
      label: Text(_emergencyLabel(request.emergencyLevel),
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isDark ? color.withOpacity(0.95) : color,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: isDark ? color.withOpacity(0.18) : color.withOpacity(0.13),
      side: BorderSide(color: color.withOpacity(0.45), width: 1.2),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      labelPadding: const EdgeInsets.only(left: 2, right: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _statusChip(BuildContext context) {
    final status = request.status;
    final isOpen = status == HelpRequestStatus.Active;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isOpen
        ? (isDark ? Colors.greenAccent.shade200 : AppColors.petsoliveSuccess)
        : (isDark ? AppColors.bsGray400 : AppColors.bsGray700);
    final bgColor = isOpen
        ? (isDark ? Colors.greenAccent.withOpacity(0.22) : AppColors.petsoliveSuccess.withOpacity(0.18))
        : (isDark ? AppColors.bsGray700.withOpacity(0.22) : AppColors.bsGray300.withOpacity(0.22));
    return Chip(
      label: Text(_statusLabel(status),
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: bgColor,
      side: BorderSide(color: color.withOpacity(0.45), width: 1.1),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      labelPadding: const EdgeInsets.only(left: 2, right: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
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
            // Sağ üstte chipler
            Positioned(
              top: 10,
              right: 14,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _emergencyChip(context),
                  const SizedBox(width: 6),
                  _statusChip(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar or placeholder
                  _SafeNetworkAvatar(
                    imageUrl: request.imageUrl,
                    radius: 28,
                    backgroundColor: colorScheme.surface,
                    emergencyColor: emergencyColor,
                  ),
                  const SizedBox(width: 14),
                  // Main info
                  Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

class _SafeNetworkAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color backgroundColor;
  final Color emergencyColor;
  const _SafeNetworkAvatar({this.imageUrl, required this.radius, required this.backgroundColor, required this.emergencyColor});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: Icon(Icons.volunteer_activism, color: emergencyColor, size: 32),
      );
    }
    return FutureBuilder<ImageProvider>(
      future: _tryLoadImage(imageUrl!, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: backgroundColor,
            backgroundImage: snapshot.data,
          );
        } else if (snapshot.hasError) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: backgroundColor,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              height: radius * 1.2,
              color: emergencyColor.withOpacity(0.5),
              colorBlendMode: BlendMode.modulate,
            ),
          );
        } else {
          // Loading or waiting
          return CircleAvatar(
            radius: radius,
            backgroundColor: backgroundColor,
            child: Icon(Icons.volunteer_activism, color: emergencyColor.withOpacity(0.5), size: 32),
          );
        }
      },
    );
  }

  Future<ImageProvider> _tryLoadImage(String url, BuildContext context) async {
    try {
      // Önce HTTP HEAD isteği ile görselin varlığını kontrol et
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        final image = NetworkImage(url);
        // Precache (artık hata beklenmiyor)
        await precacheImage(image, context);
        return image;
      } else {
        throw Exception('Image not found');
      }
    } catch (e) {
      // Herhangi bir hata, placeholder göster
      throw Exception('Image load failed');
    }
  }
} 