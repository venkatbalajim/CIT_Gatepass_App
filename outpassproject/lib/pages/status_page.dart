import '../utils/imports.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  UserDetails userDetails = UserDetails();
  StatusValidation statusCheck = StatusValidation();

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
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

  Color? getStatusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green[700];
      case "Declined":
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
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
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? currentUserEmail = user!.email;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
      future: userDetails.getUserDetails(currentUserEmail!),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                )),
          );
        } else if (snapshot.hasError) {
          showErrorDialog(
              context, "Sorry, an error occurred. Please try later.");
          return const SizedBox();
        } else {
          Map<String, dynamic> userData = snapshot.data!.data()!;
          String docId = snapshot.data!.id;
          int advisor = userData['advisor_status'];
          int hod = userData['hod_status'];
          int warden = userData['warden_status'];
          int? result = statusCheck.checkStatus(advisor, hod, warden);
          String? buttonName = statusCheck.buttonName(
              userData['advisor_status'],
              userData['hod_status'],
              userData['warden_status']);
          String? outpassStatus = statusCheck.outpassStatus(
              userData['advisor_status'],
              userData['hod_status'],
              userData['warden_status']);
          return SafeArea(
              child: RefreshIndicator(
            backgroundColor: Theme.of(context).colorScheme.primary,
            color: Colors.white,
            onRefresh: () async {
              await userDetails.getUserDetails(currentUserEmail);
              await Future.delayed(const Duration(seconds: 1));
              setState(() {});
            },
            // ignore: deprecated_member_use
            child: Scaffold(
              body: ListView(padding: const EdgeInsets.all(30), children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Outpass Status",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromRGBO(13, 71, 161, 1),
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Status: $outpassStatus",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: getStatusColor(outpassStatus!),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            InfoCard(
                                label: 'Class Advisor',
                                detail: statusCheck
                                    .currentStatus(userData['advisor_status'])),
                            InfoCard(
                                label: 'HoD',
                                detail: statusCheck
                                    .currentStatus(userData['hod_status'])),
                            InfoCard(
                                label: 'Hostel Warden',
                                detail: statusCheck
                                    .currentStatus(userData['warden_status'])),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromRGBO(13, 71, 161, 1),
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Outpass Preview",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            InfoCard(
                                label: 'Submit date',
                                detail: userData['submit_date']),
                            InfoCard(
                                label: 'Purpose', detail: userData['purpose']),
                            InfoCard(
                                label: 'Out date',
                                detail: userData['out_date']),
                            InfoCard(
                                label: 'Out time',
                                detail: userData['out_time']),
                            InfoCard(
                                label: 'In date', detail: userData['in_date']),
                            InfoCard(
                                label: 'In time', detail: userData['in_time']),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const InstructionCard(
                          instruction:
                              "If your outpass status is DECLINED, click CANCEL OUTPASS to submit new outpass."),
                      const SizedBox(height: 10),
                      if (result == 1)
                        GetQRButton(
                            name: buttonName!,
                            onTap: () {
                              statusCheck.nextPage(context, result!, docId);
                            }),
                      const SizedBox(height: 10),
                      CancelButton(
                          name: 'Cancel Outpass',
                          onTap: () async {
                            bool? confirm = await showConfirmationDialog(
                                context,
                                "Are you sure to cancel your outpass? This cannot be undone.");
                            if (confirm != null && confirm) {
                              QRValidation validation = QRValidation();
                              // ignore: use_build_context_synchronously
                              validation.eraseAll(context);
                            }
                          }),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ]),
            ),
          ));
        }
      },
    );
  }
}
