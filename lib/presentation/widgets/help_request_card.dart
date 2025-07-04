import 'package:flutter/material.dart';

class HelpRequestCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String status;
  final VoidCallback? onTap;

  const HelpRequestCard({
    Key? key,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(location, style: Theme.of(context).textTheme.bodySmall),
                  const Spacer(),
                  Chip(
                    label: Text(status),
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 