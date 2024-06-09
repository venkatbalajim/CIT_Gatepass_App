// ignore_for_file: use_build_context_synchronously

import '../../utils/imports.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<void> showLoadingDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
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
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )),
        );
      },
    );
  }

  void hideLoadingDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
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
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 50,
                  child: SmallButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    name: 'Ok',
                  ),
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        // ignore: deprecated_member_use
        child: WillPopScope(
          child: Scaffold(
              body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  "Security Authentication",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 50),
                PasswordField(controller: passwordController),
                const SizedBox(height: 50),
                SmallButton(
                  name: "Verify",
                  onTap: () async {
                    showLoadingDialog();
                    UserDetails securityUser = UserDetails();
                    final password = await securityUser.fetchPassword();
                    String enteredPassword = passwordController.text;
                    hideLoadingDialog();
                    if (password == enteredPassword) {
                      Navigator.pushReplacementNamed(context, '/options');
                    } else {
                      showErrorDialog(context, "Enter the correct password");
                    }
                  },
                )
              ],
            ),
          )),
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          },
        ),
      ),
    );
  }
}
