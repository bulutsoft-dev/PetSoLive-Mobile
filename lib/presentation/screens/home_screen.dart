import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/pet_card.dart';
import '../widgets/help_request_card.dart';
import 'pet_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int)? onTabChange;
  const HomeScreen({Key? key, this.onTabChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Örnek veri
    final pets = [
      {
        'name': 'Mia',
        'species': 'Cat',
        'imageUrl': 'https://placekitten.com/200/200',
        'description': 'A playful and friendly kitten looking for a home.',
      },
      {
        'name': 'Max',
        'species': 'Dog',
        'imageUrl': 'https://placedog.net/200/200',
        'description': 'Energetic and loyal, loves to play fetch.',
      },
    ];

    final helpRequests = [
      {
        'title': 'Lost Dog',
        'description': 'Brown dog missing since yesterday in Kadıköy.',
        'location': 'Kadıköy, Istanbul',
        'status': 'Open',
      },
      {
        'title': 'Need Food for Stray Cats',
        'description': 'Looking for food donations for stray cats in the park.',
        'location': 'Central Park',
        'status': 'Pending',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.secondary.withOpacity(0.08),
            colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pets, size: 72, color: colorScheme.primary),
              const SizedBox(height: 16),
              Text('home.title', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)).tr(),
              const SizedBox(height: 8),
              Text('home.welcome', style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _HomeActionCard(
                      icon: Icons.pets,
                      title: 'animals.title',
                      description: 'home.animals_desc',
                      color: colorScheme.primary,
                      onTap: () => onTabChange?.call(0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _HomeActionCard(
                      icon: Icons.search,
                      title: 'lost_pets.title',
                      description: 'home.lost_pets_desc',
                      color: colorScheme.secondary,
                      onTap: () => onTabChange?.call(1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _HomeActionCard(
                      icon: Icons.volunteer_activism,
                      title: 'help_requests.title',
                      description: 'home.help_requests_desc',
                      color: colorScheme.tertiary ?? colorScheme.primary,
                      onTap: () => onTabChange?.call(3),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('home.featured_pets', style: theme.textTheme.titleLarge).tr(),
          ),
          ...pets.map((pet) => PetCard(
                name: pet['name']!,
                species: pet['species']!,
                imageUrl: pet['imageUrl']!,
                description: pet['description']!,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => PetDetailScreen(
                      name: pet['name']!,
                      species: pet['species']!,
                      imageUrl: pet['imageUrl']!,
                      description: pet['description']!,
                    ),
                  ));
                },
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('home.help_requests', style: theme.textTheme.titleLarge).tr(),
          ),
          ...helpRequests.map((req) => HelpRequestCard(
                title: req['title']!,
                description: req['description']!,
                location: req['location']!,
                status: req['status']!,
                onTap: () {},
              )),
        ],
      ),
    );
  }
}

class _HomeActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _HomeActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.10),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                radius: 24,
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 10),
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: color)).tr(),
              const SizedBox(height: 4),
              Text(description, style: theme.textTheme.bodySmall, textAlign: TextAlign.center).tr(),
            ],
          ),
        ),
      ),
    );
  }
}
