import '../utils/imports.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void showConfirmationDialog(BuildContext context, String message) async {
    return showDialog(
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
                FirebaseService.signOutFromGoogle(context);
              },
              child: const Text('Yes',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No',
                  style: TextStyle(
                      color: Colors.green[700], fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ListView(padding: const EdgeInsets.all(30), children: [
        Text(
          "Settings",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 40),
        TextButton(
            style: ButtonStyle(
                alignment: Alignment.center,
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)))),
            onPressed: () {
              showConfirmationDialog(
                  context, 'Are you sure to Logout? This cannot be undone.');
            },
            child: const Text('Logout', style: TextStyle(fontSize: 15))),
      ]),
    ));
  }
}
