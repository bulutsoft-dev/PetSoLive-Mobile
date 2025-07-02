import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AnimalsScreen extends StatelessWidget {
  const AnimalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('animals.title', style: Theme.of(context).textTheme.titleLarge).tr(),
    );
  }
} 