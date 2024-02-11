import 'imports.dart';

class Routes {

  // Student Pages Routes
  static const String options = '/options';
  static const String profile = '/profile';
  static const String outpass = '/outpass';
  static const String status = '/status';
  static const String outpassQr = '/outpassqr';

  static Map<String, WidgetBuilder> getRoutes() {
    return {

      // Student Pages Routes
      options: (context) => const HomePage(),
      profile: (context) => const ProfilePage(),
      outpass: (context) => const OutpassPage(),
      status: (context) => const StatusPage(),
      outpassQr: (context) => const QRPage(),
      
    };
  }
}
