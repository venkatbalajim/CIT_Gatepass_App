import 'imports.dart';

class Routes {

  // Student Pages Routes
  static const String options = '/options';
  static const String profile = '/profile';
  static const String submission = '/submission';
  static const String dashboard = '/dashboard';
  static const String principal = '/principal';
  static const String database = '/database';

  static Map<String, WidgetBuilder> getRoutes() {
    return {

      // Student Pages Routes
      options: (context) => const HomePage(),
      profile: (context) => const ProfilePage(),
      submission: (context) => const SubmissionPage(),
      dashboard: (context) => const DashboardPage(),
      principal: (context) => const PrincipalPage(),
      database: (context) => const DatabasePage(),
      
    };
  }
}
