// ignore_for_file: avoid_print

import 'utils/imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
      title: "Hostel Outpass App",
      initialRoute: '/',
      routes: Routes.getRoutes(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
        dataTableTheme: DataTableThemeData(
          headingTextStyle: const TextStyle(
            color: Colors.white,
          ),
          headingRowColor: MaterialStateProperty.all(
            Colors.blue[900]
          ),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(13, 71, 161, 1),
                width: 2,
              )
            )
          )
        )
      ),
    );
  }
}
