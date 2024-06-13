import 'imports.dart';

final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.transparent,
        background: Colors.white,
        primary: Colors.blue[900]),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
    )),
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.blue[900],
        selectionColor: Colors.blue[200],
        selectionHandleColor: Colors.blue[900]),
    textTheme: GoogleFonts.poppinsTextTheme(),
    useMaterial3: true);
