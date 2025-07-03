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
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(request.userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(request.status, context).withOpacity(0.13),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _statusColor(request.status, context), width: 1),
                  ),
                  child: Text(request.status, style: TextStyle(color: _statusColor(request.status, context), fontWeight: FontWeight.w600, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (request.message != null && request.message!.isNotEmpty)
              Text(request.message!, style: TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.pets, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(request.petName, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                const Spacer(),
                Icon(Icons.calendar_today, size: 13, color: Colors.grey),
                const SizedBox(width: 3),
                Text(DateFormat('dd.MM.yyyy').format(request.requestDate), style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 