import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LostPetsScreen extends StatelessWidget {
  const LostPetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('lost_pets.title', style: Theme.of(context).textTheme.titleLarge).tr(),
    );
  }
} 