import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

class PetCard extends StatelessWidget {
  final String name;
  final String species;
  final String imageUrl;
  final String description;
  final int? age;
  final String? gender;
  final String? color;
  final String? vaccinationStatus;
  final bool isAdopted;
  final String? ownerName;
  final VoidCallback? onTap;

  const PetCard({
    Key? key,
    required this.name,
    required this.species,
    required this.imageUrl,
    required this.description,
    this.age,
    this.gender,
    this.color,
    this.vaccinationStatus,
    this.isAdopted = false,
    this.ownerName,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool adopted = isAdopted;
    final String ribbonText = adopted ? 'pets.adopted'.tr() : 'pets.waiting'.tr();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color ribbonColor = adopted ? colorScheme.error : colorScheme.secondary;
    final Color cardBg = colorScheme.surface;
    final Color textColor = colorScheme.onSurface;
    final Color subTextColor = isDark ? Colors.grey[400]! : Colors.grey[700]!;
    final dateFormat = DateFormat('dd.MM.yyyy');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Material(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: colorScheme.background,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: colorScheme.background,
                              child: Icon(Icons.pets, size: 36, color: subTextColor),
                            ),
                          )
                        : Center(child: Icon(Icons.pets, size: 36, color: subTextColor)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, right: 12, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: textColor, fontSize: 17),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.pets, size: 15, color: subTextColor),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(species, style: TextStyle(fontSize: 13, color: subTextColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                              if (breed != null && breed!.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Icon(Icons.label_important_outline, size: 15, color: subTextColor),
                                const SizedBox(width: 2),
                                Flexible(
                                  child: Text(breed!, style: TextStyle(fontSize: 13, color: subTextColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (age != null) ...[
                                Icon(Icons.cake, size: 15, color: subTextColor),
                                const SizedBox(width: 2),
                                Flexible(child: Text('Yaş: $age', style: TextStyle(fontSize: 12, color: subTextColor), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 8),
                              ],
                              if (gender != null && gender!.isNotEmpty) ...[
                                Icon(Icons.wc, size: 15, color: subTextColor),
                                const SizedBox(width: 2),
                                Flexible(child: Text(gender!, style: TextStyle(fontSize: 12, color: subTextColor), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 8),
                              ],
                              if (color != null && color!.isNotEmpty) ...[
                                Icon(Icons.color_lens, size: 15, color: subTextColor),
                                const SizedBox(width: 2),
                                Flexible(child: Text(color!, style: TextStyle(fontSize: 12, color: subTextColor), maxLines: 1, overflow: TextOverflow.ellipsis)),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (vaccinationStatus != null && vaccinationStatus!.isNotEmpty) ...[
                                Icon(Icons.vaccines, size: 15, color: subTextColor),
                                const SizedBox(width: 2),
                                Flexible(child: Text(vaccinationStatus!, style: TextStyle(fontSize: 12, color: subTextColor), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 8),
                              ],
                              if (microchipId != null && microchipId!.isNotEmpty) ...[
                                Icon(Icons.qr_code, size: 15, color: subTextColor),
                                const SizedBox(width: 2),
                                Flexible(child: Text(microchipId!, style: TextStyle(fontSize: 12, color: subTextColor), maxLines: 1, overflow: TextOverflow.ellipsis)),
                              ],
                            ],
                          ),
                          if (dateOfBirth != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 14, color: subTextColor),
                                  const SizedBox(width: 2),
                                  Text(dateFormat.format(dateOfBirth!), style: TextStyle(fontSize: 12, color: subTextColor)),
                                ],
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: subTextColor, fontSize: 13),
                          ),
                          if (isAdopted && ownerName != null && ownerName!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 2),
                              child: Row(
                                children: [
                                  Icon(Icons.person, size: 15, color: subTextColor),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      'pets.owner'.tr(args: [ownerName!]),
                                      style: TextStyle(fontSize: 12, color: subTextColor, fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Uyumlu ve lokalize badge, duruma göre renkli
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 120),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: adopted
                          ? [Color(0xFF43EA7A), Color(0xFF1DB954)] // Yeşil tonları (owned)
                          : [Color(0xFFFFE082), Color(0xFFFFB300)], // Sarı-turuncu tonları (waiting)
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: adopted
                            ? Color(0xFF1DB954).withOpacity(0.18)
                            : Color(0xFFFFB300).withOpacity(0.18),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        adopted ? Icons.verified : Icons.hourglass_bottom,
                        size: 15,
                        color: adopted ? Colors.white : Color(0xFF795548),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          adopted ? 'pets.owned'.tr() : 'pets.waiting'.tr(),
                          style: TextStyle(
                            color: adopted ? Colors.white : Color(0xFF795548),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ekstra alanlar için getter
  String? get breed => null;
  String? get microchipId => null;
  DateTime? get dateOfBirth => null;
} 