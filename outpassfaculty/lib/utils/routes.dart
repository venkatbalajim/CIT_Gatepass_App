import 'imports.dart';

class Routes {
  // Student Pages Routes
  static const String options = '/options';
  static const String profile = '/profile';
  static const String submission = '/submission';
  static const String dashboard = '/dashboard';
  static const String principal = '/principal';
  static const String database = '/database';
  static const String welcome = '/welcome';
  static const String selectDB = '/selectdb';
  static const String security = '/security';
  static const String students = '/students';
  static const String faculty = '/faculty';
  static const String warden = '/warden';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Student Pages Routes
      options: (context) => const HomePage(),
      profile: (context) => const ProfilePage(),
      submission: (context) => const SubmissionPage(),
      dashboard: (context) => const DashboardPage(),
      principal: (context) => const PrincipalPage(),
      database: (context) => const DatabasePage(),
      welcome: (context) => const WelcomePage(),
      selectDB: (context) => const SelectDatabasePage(),
      security: (context) => const SecurityDBPage(),
      students: (context) => const StudentsDBPage(),
      faculty: (context) => const FacultyDBPage(),
      warden: (context) => const WardenDBPage()
    };
  }
}
