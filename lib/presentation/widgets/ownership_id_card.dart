import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class OwnershipIdCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String name;
  final String dateLabel;
  final String date;
  final String badge;
  final Color? badgeColor;
  final String explanation;
  final Color? explanationColor;
  final String? avatarImagePath; // Kullanıcıya özel avatar için opsiyonel
  const OwnershipIdCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.name,
    required this.dateLabel,
    required this.date,
    required this.badge,
    this.badgeColor,
    required this.explanation,
    this.explanationColor,
    this.avatarImagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),

      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23272F) : const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: isDark ? Colors.blueGrey[700]! : const Color(0xFFB0BEC5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          image: AssetImage('assets/images/logo.png'),
          fit: BoxFit.fill,
          alignment: Alignment.center,
          repeat: ImageRepeat.noRepeat,
          opacity: 0.15,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Üst satır: başlıklar ve logo
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sol başlıklar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PETSOLIVE',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.teal[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'KULLANICI KARTI',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        letterSpacing: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const Spacer(),
                // Sağ üstte logo
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Alt satır: avatar ve bilgiler
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.13),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: color.withOpacity(0.25), width: 1.1),
                  ),
                  child: avatarImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(avatarImagePath!, fit: BoxFit.cover),
                        )
                      : Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 14),
                // Bilgiler
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 13, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('$dateLabel: ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.grey[700])),
                          Text(date, style: theme.textTheme.bodySmall?.copyWith(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (explanation.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 2, right: 2),
                child: Text(
                  explanation,
                  style: theme.textTheme.bodySmall?.copyWith(color: explanationColor ?? Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
          ],
        ),
      ),
    );
  }
}