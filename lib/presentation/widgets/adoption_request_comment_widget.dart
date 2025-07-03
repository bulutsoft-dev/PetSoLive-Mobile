import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/adoption_request_dto.dart';
import '../themes/colors.dart';

class AdoptionRequestCommentWidget extends StatelessWidget {
  final AdoptionRequestDto request;
  const AdoptionRequestCommentWidget({Key? key, required this.request}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: isDark ? AppColors.darkSurface : AppColors.surface,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _statusColor(request.status, context).withOpacity(0.15),
                  child: Icon(Icons.person, color: _statusColor(request.status, context)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    request.userName ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(request.status, context).withOpacity(0.13),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _statusColor(request.status, context), width: 1),
                  ),
                  child: Text(
                    request.status,
                    style: TextStyle(
                      color: _statusColor(request.status, context),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (request.message != null && request.message!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  request.message!,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd.MM.yyyy').format(request.requestDate),
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                const Spacer(),
                Icon(Icons.pets, size: 15, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  request.petName,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 