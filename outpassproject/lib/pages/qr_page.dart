// ignore_for_file: avoid_print, use_build_context_synchronously

import '../utils/imports.dart';

class QRPage extends StatefulWidget {
  final String documentId;
  const QRPage({super.key, required this.documentId});

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  late String qrData;

  UserDetails userDetails = UserDetails();

  @override
  void initState() {
    super.initState();
    String encryptedData = base64Encode(utf8.encode(widget.documentId));
    print("Original data: ${widget.documentId}");
    print("Encrypted data is $encryptedData");
    setState(() {
      qrData = widget.documentId;
    });
    disableScreenshots();
  }

  Future<void> disableScreenshots() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const Text('Permission Denied'),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            )
          ],
        );
      },
    );
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
              child: Text('Yes',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<int> departStatus() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String? currentUserEmail = user?.email;
      UserDetails userDetails = UserDetails();
      final userData = await userDetails.getUserDetails(currentUserEmail!);
      return userData!['depart_status'];
    }

    // ignore: deprecated_member_use
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Outpass QR Code",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: QrImageView(
                      data: qrData,
                      gapless: false,
                      size: 200,
                      version: QrVersions.auto,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CancelButton(
                      name: 'Cancel Outpass',
                      onTap: () async {
                        int depart = await departStatus();
                        if (depart == 0) {
                          bool? confirm = await showConfirmationDialog(context,
                              "Are you sure to cancel your outpass? This cannot be undone.");
                          if (confirm != null && confirm) {
                            QRValidation validation = QRValidation();
                            validation.eraseAll(context);
                          }
                        } else {
                          showErrorDialog(context,
                              "Sorry, you already used this Outpass QR Code. So you cannot cancel your Outpass.");
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
