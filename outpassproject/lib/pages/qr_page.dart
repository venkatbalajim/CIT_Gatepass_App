// ignore_for_file: avoid_print

import '../utils/imports.dart';

class QRPage extends StatefulWidget {
  const QRPage({super.key});

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  final textController = TextEditingController();
  late String textData;
  late String qrData;
  bool showQrCode = false;
  bool isEditMode = true;
  bool buttonView = true;

  UserDetails userDetails = UserDetails();
  late Future<String> registerNo = userDetails.getRegisterNo();

  Future<bool> isCorrect(String textData, Future<String> registerNoFuture) async {
    String registerNo = await registerNoFuture;
    bool match = textData == registerNo;
    print("Is matched? $match");
    if (match) {
      String encryptedData = base64Encode(utf8.encode(textData));
      print("Encrypted data is $encryptedData");
      setState(() {
        qrData = encryptedData;
      });
    }
    print("Data in QR code is $qrData");
    return match;
  }

  @override
  void initState() {
    super.initState();
    qrData = '';
    textData = '';
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
            padding: const EdgeInsets.all(15),
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
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 70,
                  child: SmallButton(name: 'Ok', onTap: () {Navigator.pop(context);}),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> showConfirmationDialog(BuildContext context, String message) async {
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
    // ignore: deprecated_member_use
    return WillPopScope(
      child: SafeArea(
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
                    const SizedBox(height: 50,),
                    Text(
                      "Outpass QR Code",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 50,),
                    if (isEditMode) 
                      RegNoField(
                        qrDataController: textController,
                        onDataChanged: (data) {
                          setState(() {
                            textData = data;
                          });
                        },
                      ),
                    const SizedBox(height: 20,),
                    if (buttonView) 
                    SmallButton(
                      onTap: () {
                        Future<bool> status = isCorrect(textData, registerNo);
                        status.then((value){
                          if (value) {
                            setState(() {
                              isEditMode = false;
                              showQrCode = true; 
                              buttonView = false;
                            });
                          } else {
                            showErrorDialog(context, 'Kindly enter your register number correctly.');
                          }
                        });
                      },
                      name: 'Proceed',
                    ),
                    const SizedBox(height: 30,),
                    if (showQrCode)
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
                        SmallButton(name: 'Cancel Outpass', onTap: () async {
                          bool? confirm = await showConfirmationDialog(context, "Are you sure to cancel your outpass? This cannot be undone.");
                          if (confirm != null && confirm) {
                            QRValidation validation = QRValidation();
                            // ignore: use_build_context_synchronously
                            validation.eraseAll(context);
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.settings.name == '/options');
        return true;
      },
    );
  }
}
