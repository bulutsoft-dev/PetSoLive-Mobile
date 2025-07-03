import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/theme_cubit.dart';
import '../themes/colors.dart';

class PetDetailScreen extends StatelessWidget {
  final String name;
  final String species;
  final String breed;
  final int? age;
  final String? gender;
  final double? weight;
  final String? color;
  final DateTime? dateOfBirth;
  final String description;
  final String? vaccinationStatus;
  final String? microchipId;
  final bool? isNeutered;
  final String imageUrl;
  final bool isAdopted;
  final String? ownerName;

  const PetDetailScreen({
    Key? key,
    required this.name,
    required this.species,
    required this.breed,
    this.age,
    this.gender,
    this.weight,
    this.color,
    this.dateOfBirth,
    required this.description,
    this.vaccinationStatus,
    this.microchipId,
    this.isNeutered,
    required this.imageUrl,
    this.isAdopted = false,
    this.ownerName,
  }) : super(key: key);

  Color? _getColor(String? colorName) {
    if (colorName == null) return null;
    final c = colorName.toLowerCase();
    if (c.contains('siyah') || c.contains('black')) return Colors.black;
    if (c.contains('beyaz') || c.contains('white')) return Colors.white;
    if (c.contains('gri') || c.contains('gray') || c.contains('grey')) return Colors.grey;
    if (c.contains('kahverengi') || c.contains('brown')) return Colors.brown;
    if (c.contains('sarı') || c.contains('yellow')) return Colors.yellow[700];
    if (c.contains('kırmızı') || c.contains('red')) return Colors.red;
    if (c.contains('turuncu') || c.contains('orange')) return Colors.orange;
    if (c.contains('mavi') || c.contains('blue')) return Colors.blue;
    if (c.contains('yeşil') || c.contains('green')) return Colors.green;
    return null;
  }

  void _showOwnerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text('pet_detail.owner'.tr()),
          ],
        ),
        content: Text(ownerName ?? '-'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.petsoliveBg,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.darkPrimary : AppColors.petsolivePrimary,
        ),
        titleTextStyle: TextStyle(
          color: isDark ? AppColors.darkPrimary : AppColors.petsolivePrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Geri',
        ),
        title: Text(
          name,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            tooltip: 'Dili Değiştir',
            onPressed: () {
              final current = context.locale;
              final newLocale = current.languageCode == 'tr' ? const Locale('en') : const Locale('tr');
              context.setLocale(newLocale);
            },
            color: isDark ? AppColors.darkPrimary : AppColors.petsolivePrimary,
          ),
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? AppColors.darkPrimary : AppColors.petsolivePrimary,
            ),
            tooltip: isDark ? 'Aydınlık Tema' : 'Karanlık Tema',
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
          IconButton(
            icon: Icon(
              isAdopted ? Icons.verified : Icons.hourglass_bottom,
              color: isAdopted ? Colors.green : Colors.amber[800],
            ),
            tooltip: isAdopted ? 'pet_detail.status_owned'.tr() : 'pet_detail.status_waiting'.tr(),
            onPressed: null,
          ),
          if (ownerName != null && ownerName!.isNotEmpty)
            IconButton(
              icon: const Text('👤', style: TextStyle(fontSize: 22)),
              tooltip: 'pet_detail.owner'.tr(),
              onPressed: () => _showOwnerDialog(context),
              color: isDark ? AppColors.darkPrimary : AppColors.petsolivePrimary,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                imageUrl,
                height: 220,
                width: 220,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  width: 220,
                  color: Colors.grey[300],
                  child: const Icon(Icons.pets, size: 80),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const SizedBox(height: 22),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            color: isDark ? colorScheme.surfaceVariant : colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PetDetailRow(
                    emoji: '🐾',
                    label: 'pet_detail.species'.tr(),
                    value: species,
                  ),
                  _PetDetailRow(
                    emoji: '🧬',
                    label: 'pet_detail.breed'.tr(),
                    value: breed,
                  ),
                  if (age != null)
                    _PetDetailRow(
                      emoji: '🎂',
                      label: 'pet_detail.age'.tr(),
                      value: age.toString(),
                    ),
                  if (gender != null && gender!.isNotEmpty)
                    _PetDetailRow(
                      emoji: gender!.toLowerCase().contains('d') || gender!.toLowerCase().contains('f') ? '♀️' : '♂️',
                      label: 'pet_detail.gender'.tr(),
                      value: gender!,
                      valueColor: gender!.toLowerCase().contains('d') || gender!.toLowerCase().contains('f') ? Colors.pink[400] : Colors.blue[400],
                    ),
                  if (weight != null)
                    _PetDetailRow(
                      emoji: '⚖️',
                      label: 'pet_detail.weight'.tr(),
                      value: '${weight!.toStringAsFixed(1)} kg',
                    ),
                  if (color != null && color!.isNotEmpty)
                    _PetDetailRow(
                      emoji: '🎨',
                      label: 'pet_detail.color'.tr(),
                      value: color!,
                      valueColor: _getColor(color),
                    ),
                  if (dateOfBirth != null)
                    _PetDetailRow(
                      emoji: '📅',
                      label: 'pet_detail.date_of_birth'.tr(),
                      value: dateFormat.format(dateOfBirth!),
                    ),
                  if (vaccinationStatus != null && vaccinationStatus!.isNotEmpty)
                    _PetDetailRow(
                      emoji: '💉',
                      label: 'pet_detail.vaccination_status'.tr(),
                      value: vaccinationStatus!,
                      valueColor: Colors.teal[700],
                    ),
                  if (microchipId != null && microchipId!.isNotEmpty)
                    _PetDetailRow(
                      emoji: '🔗',
                      label: 'pet_detail.microchip_id'.tr(),
                      value: microchipId!,
                      valueColor: Colors.deepPurple[400],
                    ),
                  if (isNeutered != null)
                    _PetDetailRow(
                      emoji: '✂️',
                      label: 'pet_detail.is_neutered'.tr(),
                      value: isNeutered! ? 'pet_detail.yes'.tr() : 'pet_detail.no'.tr(),
                      valueColor: isNeutered! ? Colors.green[700] : Colors.red[700],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Card(
            color: isDark ? Colors.blueGrey[900] : Colors.blue[50],
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('📝', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text('pet_detail.description'.tr(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(description, style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Card(
            color: isDark ? Colors.grey[900] : Colors.grey[100],
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('💬', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text('Yorumlar', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Bu bölümde hayvana gelen yorumları görebileceksiniz.', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text('Henüz yorum yok.', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
            label: Text('pet_detail.adopt').tr(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetDetailRow extends StatelessWidget {
  final String? emoji;
  final String label;
  final String value;
  final Color? valueColor;
  const _PetDetailRow({this.emoji, required this.label, required this.value, this.valueColor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (emoji != null) Text(emoji!, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: valueColor != null ? FontWeight.w600 : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 