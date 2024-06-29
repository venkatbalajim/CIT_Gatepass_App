import '../../utils/imports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const button_1 = "User Profile";
  static const button_2 = "Outpass";
  static const button_3 = "Dashboard";
  static const button_4 = "Logout";
  static const button_5 = "Database";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _backButtonPressedOnce = false;
  DateTime? _lastBackPressed;

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          child: SizedBox(
            width: 250,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 60,
                  child: SmallButton(
                      name: 'Ok',
                      onTap: () {
                        Navigator.pop(context);
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? currentUserEmail = user!.email;
    UserDetails userDetail = UserDetails();

    // ignore: deprecated_member_use
    return WillPopScope(
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
      child: FutureBuilder(
        future: userDetail.getUserDetails(currentUserEmail!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SafeArea(
              child: Scaffold(
                body: Center(
                  child: Dialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    child: SizedBox(
                      width: 250,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 50),
                          CircularProgressIndicator(
                            color: Color.fromRGBO(13, 71, 161, 1),
                          ),
                          SizedBox(height: 30),
                          Text(
                            "Please wait a moment",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            showErrorDialog(
                context, "Sorry, an error occurred. Please try later.");
            return const SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
              ),
            );
          } else {
            final userData = snapshot.data?.data();
            return SafeArea(
              child: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hostel Outpass Application",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      (userData!['admin'] == 'yes')
                          ? const SizedBox(height: 150)
                          : const SizedBox(height: 200),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GridButton(context, button_1),
                          const SizedBox(width: 10),
                          GridButton(context, button_2),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GridButton(context, button_3),
                          const SizedBox(width: 10),
                          GridButton(context, button_4),
                        ],
                      ),
                      if (userData['admin'] == 'yes')
                        const SizedBox(height: 10),
                      if (userData['admin'] == 'yes')
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GridButton(context, HomePage.button_5),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
