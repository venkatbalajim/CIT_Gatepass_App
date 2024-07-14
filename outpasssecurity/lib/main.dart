import 'utils/imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessagingService().initNotifications();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Outpass Security App',
      home: const AuthPage(),
      initialRoute: '/',
      routes: Routes.getRoutes(),
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          textSelectionTheme: TextSelectionThemeData(
              selectionHandleColor: Colors.blue[900],
              selectionColor: Colors.blue[200])),
    );
  }
}
