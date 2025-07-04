// Uygulama rotaları burada olacak 

import 'package:flutter/material.dart';
import '../presentation/screens/pets_screen.dart';
import '../presentation/screens/lost_pets_screen.dart';
import '../presentation/screens/help_requests_screen.dart';
import '../presentation/screens/lost_pet_ad_screen.dart';
import '../presentation/screens/help_request_screen.dart';
// import '../presentation/screens/help_request_screen.dart';

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
      case '/lost_pet_ad': {
        final adId = settings.arguments;
        if (adId is int) {
          return MaterialPageRoute(builder: (_) => LostPetAdScreen(adId: adId));
        } else {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('404 - Kayıp ilanı bulunamadı')),
            ),
          );
        }
      }
      case '/help_request': {
        final reqId = settings.arguments;
        if (reqId is int) {
          return MaterialPageRoute(builder: (_) => HelpRequestScreen(requestId: reqId));
        } else {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('404 - Yardım talebi bulunamadı')),
            ),
          );
        }
      }
      // case '/help_request':
      //   final reqId = settings.arguments as int?;
      //   return MaterialPageRoute(builder: (_) => HelpRequestScreen(requestId: reqId));
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