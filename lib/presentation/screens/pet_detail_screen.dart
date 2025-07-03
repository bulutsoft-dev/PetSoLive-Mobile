import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PetDetailScreen extends StatelessWidget {
  final String name;
  final String species;
  final String imageUrl;
  final String description;
  final int? age;
  final String? gender;
  final String? color;
  final String? vaccinationStatus;
  // final String? ownerName; // İleride sahip bilgisi için

  const PetDetailScreen({
    Key? key,
    required this.name,
    required this.species,
    required this.imageUrl,
    required this.description,
    this.age,
    this.gender,
    this.color,
    this.vaccinationStatus,
    // this.ownerName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pet_detail.title'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imageUrl,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                color: Colors.grey[300],
                child: const Icon(Icons.pets, size: 60),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(species, style: Theme.of(context).textTheme.bodyMedium),
          if (age != null) ...[
            const SizedBox(height: 8),
            Text('Yaş: $age'),
          ],
          if (gender != null) ...[
            const SizedBox(height: 8),
            Text('Cinsiyet: $gender'),
          ],
          if (color != null) ...[
            const SizedBox(height: 8),
            Text('Renk: $color'),
          ],
          if (vaccinationStatus != null) ...[
            const SizedBox(height: 8),
            Text('Aşı Durumu: $vaccinationStatus'),
          ],
          const SizedBox(height: 16),
          Text(description, style: Theme.of(context).textTheme.bodyLarge),
          // if (ownerName != null) ...[
          //   const SizedBox(height: 16),
          //   Text('Sahibi: $ownerName'),
          // ],
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