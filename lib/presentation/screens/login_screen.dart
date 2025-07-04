import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('login.title', style: Theme.of(context).textTheme.titleLarge).tr(),
    );
  }
} 