import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petsolive/data/models/lost_pet_ad_dto.dart';

class LostPetAdCard extends StatelessWidget {
  final LostPetAdDto ad;
  final VoidCallback? onTap;
  const LostPetAdCard({Key? key, required this.ad, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String petName = (ad.petName ?? '').trim().isNotEmpty ? ad.petName : '-';
    String description = (ad.description ?? '').trim().isNotEmpty ? ad.description : '-';
    String location = (ad.lastSeenLocation ?? '').trim();
    if (location.startsWith('[')) {
      location = location.substring(1);
    }
    if (location.isEmpty) {
      location = ((ad.lastSeenCity ?? '') + (ad.lastSeenDistrict != null ? ', ${ad.lastSeenDistrict}' : '')).trim();
      if (location.isEmpty) location = '-';
    }
    DateTime? lastSeenDate = ad.lastSeenDate;
    String lastSeenDateStr = lastSeenDate != null ? DateFormat('dd.MM.yyyy').format(lastSeenDate) : '-';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Stack(
          children: [
            Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 22),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              color: theme.cardColor,
              shadowColor: theme.colorScheme.primary.withOpacity(0.08),
              child: SizedBox(
                height: 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
                          child: SizedBox(
                            width: 140,
                            height: 150,
                            child: (ad.imageUrl != null && ad.imageUrl.isNotEmpty)
                                ? Image.network(
                                    ad.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      color: theme.colorScheme.surfaceVariant,
                                      child: Icon(Icons.pets, size: 54, color: theme.colorScheme.primary),
                                    ),
                                  )
                                : Container(
                                    color: theme.colorScheme.surfaceVariant,
                                    child: Icon(Icons.pets, size: 54, color: theme.colorScheme.primary),
                                  ),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.18)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 13, color: theme.colorScheme.outline.withOpacity(0.7)),
                                const SizedBox(width: 3),
                                Text(
                                  lastSeenDateStr,
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline.withOpacity(0.7), fontWeight: FontWeight.w500, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              petName,
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                              child: Text(
                                description,
                                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12.5, color: theme.colorScheme.onSurface.withOpacity(0.82)),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 13, color: theme.colorScheme.primary.withOpacity(0.7)),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    location,
                                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary.withOpacity(0.7), fontWeight: FontWeight.w600, fontSize: 11.5),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 12,
              child: Material(
                color: theme.colorScheme.surface.withOpacity(0.92),
                borderRadius: BorderRadius.circular(20),
                elevation: 1,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final Color? bgColor;
  const _InfoBadge({required this.icon, required this.label, this.color, this.bgColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color ?? Colors.blueGrey, width: 1.1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: color ?? Colors.blueGrey),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color ?? Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
} 