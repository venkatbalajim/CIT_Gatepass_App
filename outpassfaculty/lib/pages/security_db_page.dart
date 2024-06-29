import '../utils/imports.dart';

class SecurityDBPage extends StatefulWidget {
  const SecurityDBPage({super.key});

  @override
  State<SecurityDBPage> createState() => _SecurityDBPageState();
}

class _SecurityDBPageState extends State<SecurityDBPage> {
  final TextEditingController passwordController = TextEditingController();
  SecurityDatabase database = SecurityDatabase();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<bool?> showConfirmationDialog(
      BuildContext context, String message) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: const Text('Confirmation'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: database.getSecurityPassword(),
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
          final password = snapshot.data;
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 60,
                foregroundColor: Theme.of(context).colorScheme.primary,
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: const Text(
                  "Security Database",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Column(
                    children: [
                      const Text(
                        "Current Security Password:",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        password ?? "",
                        style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      const Text(
                        "Change Security Password:",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      PasswordField(controller: passwordController),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          if (passwordController.text != "") {
                            if (passwordController.text == password) {
                            } else {
                              bool? status = await showConfirmationDialog(
                                  context,
                                  'Are you sure to update the password?');
                              if (status != null && status) {
                                database
                                    .updatePassword(passwordController.text);
                                passwordController.clear();
                                setState(() {});
                              }
                            }
                          }
                        },
                        child: SingleActionButton(
                          color: Colors.blue[900]!,
                          buttonName: 'Update',
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  const InstructionCard(
                    instruction:
                        'If you change the password, kindly tell the updated password to the security.',
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
