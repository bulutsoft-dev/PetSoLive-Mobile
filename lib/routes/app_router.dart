// Uygulama rotaları burada olacak 

import 'package:flutter/material.dart';
import '../presentation/screens/pets_screen.dart';
import '../presentation/screens/lost_pets_screen.dart';
import '../presentation/screens/help_requests_screen.dart';

/// Uygulamanın tüm rotalarını merkezi olarak yöneten sınıf.
/// Yeni bir ekran eklemek için sadece buraya case eklemen yeterli.
class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/pets':
        return MaterialPageRoute(builder: (_) => const PetsScreen());
      case '/lost_pets':
        return MaterialPageRoute(builder: (_) => const LostPetsScreen());
      case '/help_requests':
        return MaterialPageRoute(builder: (_) => const HelpRequestsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('404 - Sayfa bulunamadı')),
          ),
        );
    }
  }
}

// Kullanım örneği:
// Navigator.of(context).pushNamed('/pets');
// MaterialApp'da: onGenerateRoute: AppRouter.generateRoute, 