import 'imports.dart';

final lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent),
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
    useMaterial3: true,
    dataTableTheme: DataTableThemeData(
        headingTextStyle: const TextStyle(
          color: Colors.white,
        ),
        headingRowColor: MaterialStateProperty.all(Colors.blue[900]),
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Color.fromRGBO(13, 71, 161, 1),
          width: 2,
        )))));
