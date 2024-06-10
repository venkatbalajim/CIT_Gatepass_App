// ignore_for_file: use_build_context_synchronously

import '../utils/imports.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String errorMessage = "No Outpass QR Code Scanned.";
  Map<String, dynamic>? userData;
  final TextEditingController passwordController = TextEditingController();

  String qrValue = '';

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    qrScanner();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/options');
          return false;
        },
        child: Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 30),
              SizedBox(
                width: 320,
                child: Text(
                  "Student Outpass",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (userData != null) ...[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.green[600],
                        borderRadius: BorderRadius.circular(100)),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      badgeNumber(userData!['depart_status']),
                      style: const TextStyle(color: Colors.white, fontSize: 75),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 250,
                  child: Text(
                    "To allow the student, enter the password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 180,
                    child: PasswordField(controller: passwordController),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 150,
                    child: SmallButton(
                        name: "Verify",
                        onTap: () async {
                          showLoadingDialog();
                          UserDetails securityUser = UserDetails();
                          final password = await securityUser.fetchPassword();
                          String enteredPassword = passwordController.text;
                          if (password == enteredPassword) {
                            await Validation.updateStatus(context, qrValue);
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/options');
                          } else {
                            Navigator.pop(context);
                            showErrorDialog(
                                context, "Enter the correct password");
                          }
                        }),
                  ),
                ),
                const SizedBox(height: 40),
              ],
              userData != null
                  ? outpassDetails()
                  : SizedBox(
                      width: 250,
                      child: errorText(),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String? currentStatus(int status) {
    if (status == 0) {
      return "No";
    } else if (status == 1) {
      return "Yes";
    }
    return null;
  }

  String badgeNumber(int status) {
    if (status == 0) {
      return "1";
    } else {
      return "2";
    }
  }

  void showLoadingDialog() {
    showDialog(
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

  Widget outpassDetails() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromRGBO(13, 71, 161, 1),
          width: 2,
        ),
      ),
      alignment: Alignment.centerLeft,
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoCard(
              label: 'Depart Status',
              detail: currentStatus(userData!['depart_status'])),
          InfoCard(
              label: 'Arrival Status',
              detail: currentStatus(userData!['arrival_status'])),
          InfoCard(label: 'Name', detail: userData!['name']),
          InfoCard(label: 'Department', detail: userData!['department']),
          InfoCard(label: 'Year', detail: userData!['year']),
          InfoCard(label: 'Hostel', detail: userData!['hostel']),
          InfoCard(label: 'Submit date', detail: userData!['submit_date']),
          InfoCard(label: 'Purpose', detail: userData!['purpose']),
          InfoCard(label: 'Out date', detail: userData!['out_date']),
          InfoCard(label: 'Out time', detail: userData!['out_time']),
          InfoCard(label: 'In date', detail: userData!['in_date']),
          InfoCard(label: 'In time', detail: userData!['in_time']),
        ],
      ),
    );
  }

  Widget errorText() {
    return Text(
      errorMessage,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Future<void> qrScanner() async {
    try {
      final scannerResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'CANCEL',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      try {
        if (scannerResult != "-1") {
          qrValue = scannerResult;
          UserDetails newDetail = UserDetails();
          final outpassData = await newDetail.fetchStudentOutpass(qrValue);
          final isSubmitted = outpassData?['is_submitted'];
          if (isSubmitted == 2) {
            setState(() {
              userData = outpassData;
            });
          } else {
            showNotApprovedDialog(context);
          }
        } else {
          setState(() {
            userData = null;
          });
        }
      } catch (e) {
        showNotApprovedDialog(context);
      }
    } on PlatformException {
      setState(() {
        userData = null;
      });
    }
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
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 50,
                  child: SmallButton(
                    onTap: () {
                      Navigator.popUntil(context,
                          (route) => route.settings.name == '/scanner');
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

  void showNotApprovedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          child: SizedBox(
            width: 250,
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100)),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Invalid Outpass QR Code",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 60,
                  child: SmallButton(
                    onTap: () {
                      Navigator.popUntil(context,
                          (route) => route.settings.name == '/options');
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
}
