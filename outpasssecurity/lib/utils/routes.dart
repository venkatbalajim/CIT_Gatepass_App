import 'imports.dart';

class Routes {

  static const String home = '/options';
  static const String scanner = '/scanner';

  static Map<String, WidgetBuilder> getRoutes() {
    return {

      home: (context) => const HomePage(),
      scanner: (context) => const ScannerPage(),
      
    };
  }
}
