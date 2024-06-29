import '../utils/imports.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _backButtonPressedOnce = false;
  DateTime? _lastBackPressed;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(50),
                  child: Text(
                    "Welcome to Hostel Outpass App!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 200,
                ),
                const GoogleSignInButton(),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        if (_backButtonPressedOnce) {
          SystemNavigator.pop();
          return false;
        } else {
          CustomSnackBar.showSnackBar(context, "Press again to exit app");
          _backButtonPressedOnce = true;

          if (_lastBackPressed == null ||
              DateTime.now().difference(_lastBackPressed!) >
                  const Duration(seconds: 2)) {
            _lastBackPressed = DateTime.now();
            await Future.delayed(const Duration(seconds: 2));
          } else {
            SystemNavigator.pop();
            return true;
          }

          _backButtonPressedOnce = false;
          return false;
        }
      },
    );
  }
}
