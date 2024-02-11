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
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: const Text("Ok"),
                ),
              ],
            ),
          ),
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
        return Colors.blue[900];
    }
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
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? currentUserEmail = user!.email;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
      future: userDetails.getUserDetails(currentUserEmail!),
      builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>?> snapshot) {
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
              )
            ),
          );
        } else if (snapshot.hasError) {
          showErrorDialog(context, "Sorry, an error occurred. Please try later.");
          return const SizedBox();
        } else {
          Map<String, dynamic> userData = snapshot.data!.data()!;
          String? buttonName = statusCheck.buttonName(userData['advisor_status'], userData['hod_status'], userData['warden_status']);
          String? outpassStatus = statusCheck.outpassStatus(userData['advisor_status'], userData['hod_status'], userData['warden_status']);
          return SafeArea(
            child: RefreshIndicator(
              backgroundColor: Colors.blue[900],
              color: Colors.white,
              onRefresh: () async {
                await userDetails.getUserDetails(currentUserEmail);
                await Future.delayed(const Duration(seconds: 1));
                setState(() {});
              },
              // ignore: deprecated_member_use
              child: WillPopScope(
                onWillPop: () async {
                  Navigator.popUntil(context, (route) => route.settings.name == '/options');
                  return true;
                },
                child: Scaffold(
                  body: ListView(
                    children: [
                        Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 30,),
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
                                  const SizedBox(height: 30,),
                                  InfoCard(label: 'Class Advisor', detail: statusCheck.currentStatus(userData['advisor_status'])),
                                  InfoCard(label: 'HoD', detail: statusCheck.currentStatus(userData['hod_status'])),
                                  InfoCard(label: 'Hostel Warden', detail: statusCheck.currentStatus(userData['warden_status'])),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
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
                                      color: Colors.blue[900],
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 30,),
                                  InfoCard(label: 'Submit date', detail: userData['submit_date']),
                                  InfoCard(label: 'Purpose', detail: userData['purpose']),
                                  InfoCard(label: 'Out date', detail: userData['out_date']),
                                  InfoCard(label: 'Out time', detail: userData['out_time']),
                                  InfoCard(label: 'In date', detail: userData['in_date']),
                                  InfoCard(label: 'In time', detail: userData['in_time']),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            SmallButton(name: buttonName!, onTap: () {
                              int advisor = userData['advisor_status'];
                              int hod = userData['hod_status'];
                              int warden = userData['warden_status'];
                              int? result = statusCheck.checkStatus(advisor, hod, warden);
                              statusCheck.nextPage(context, result!);
                            }),
                            const SizedBox(height: 20),
                            SmallButton(name: 'Cancel Outpass', onTap: () async {
                              bool? confirm = await showConfirmationDialog(context, "Are you sure to cancel your outpass? This cannot be undone.");
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
                    ]
                  ),
                ), 
              )
            ),
          );
        }
      },
    );
  }
}
