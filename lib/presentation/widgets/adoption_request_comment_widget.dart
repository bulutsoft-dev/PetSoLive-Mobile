import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/adoption_request_dto.dart';
import '../themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class AdoptionRequestCommentWidget extends StatelessWidget {
  final AdoptionRequestDto request;
  final bool isOwner;
  final int petId;
  final void Function(String action, AdoptionRequestDto request)? onAction;
  const AdoptionRequestCommentWidget({Key? key, required this.request, this.isOwner = false, this.petId = 0, this.onAction}) : super(key: key);

  Color _statusColor(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppColors.petsoliveSuccess;
      case 'pending':
        return AppColors.petsoliveWarning;
      case 'rejected':
        return AppColors.petsoliveDanger;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Color _avatarColor(String name) {
    // Basit bir renk seçici (kullanıcı adına göre)
    final colors = [Colors.blue, Colors.teal, Colors.indigo, Colors.deepOrange, Colors.purple, Colors.green, Colors.brown];
    return colors[name.hashCode % colors.length].withOpacity(0.85);
  }

  String _localizedStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'adoption_request_status_approved'.tr();
      case 'pending':
        return 'adoption_request_status_pending'.tr();
      case 'rejected':
        return 'adoption_request_status_rejected'.tr();
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: _statusColor(request.status, context).withOpacity(0.18), width: 1),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: _avatarColor(request.userName ?? '-'),
                      child: Text(
                        (request.userName != null && request.userName!.isNotEmpty)
                            ? request.userName![0].toUpperCase()
                            : '-',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      radius: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        request.userName ?? '-',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (request.message != null && request.message!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    request.message!,
                    style: TextStyle(fontSize: 15.5, color: isDark ? Colors.grey[200] : Colors.grey[900]),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 15, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd.MM.yyyy').format(request.requestDate),
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.pets, size: 15, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        request.petName,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (isOwner && request.status.toLowerCase() == 'pending') ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: Text('Onayla'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => onAction?.call('approve', request),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.close, color: Colors.white),
                          label: Text('Reddet'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => onAction?.call('reject', request),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: _statusColor(request.status, context).withOpacity(0.13),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _statusColor(request.status, context), width: 1),
              ),
              child: Text(
                _localizedStatus(request.status),
                style: TextStyle(
                  color: _statusColor(request.status, context),
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 