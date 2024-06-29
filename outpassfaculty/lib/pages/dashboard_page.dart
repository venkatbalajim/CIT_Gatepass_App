// ignore_for_file: avoid_print, use_build_context_synchronously
import '../utils/imports.dart';

class DashboardPage extends StatefulWidget {
  final List<DocumentSnapshot<Map<String, dynamic>>>? documents;

  const DashboardPage({super.key, this.documents});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<DocumentSnapshot<Map<String, dynamic>>>? filteredDocuments;
  UserDetails userDetails = UserDetails();
  DashboardDetails dashboardDetails = DashboardDetails();
  bool asAdmin = false;
  String adminMessage =
      "You are now switching to Admin mode. Are you sure to proceed?";
  String downloadMsg =
      "Are you sure to delete expired outpass data in DATABASE and donwload them as CSV.";

  @override
  void initState() {
    super.initState();
    filteredDocuments = widget.documents;
    clearSelectedOptions();
  }

  void clearSelectedOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('selectedOption');
  }

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
                SizedBox(
                  width: 60,
                  child: SmallButton(
                    name: 'Ok',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
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
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>?> snapshot) {
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
          final userData = snapshot.data!.data();
          String? position = userData!['position'];
          String? department = userData['department'];
          String? college = userData['college'];
          int? year = userData['year'];
          String? section = userData['section'];
          String? hostel = userData['hostel'];
          String? isAdmin = userData['admin'] ?? '';

          void onFilterOptionSelected(String selectedOption) {
            setState(() {
              filteredDocuments = widget.documents;

              if (selectedOption == 'Not Yet Arrived') {
                filteredDocuments = filteredDocuments
                    ?.where((doc) => doc['arrival_status'] == 0)
                    .toList();
              } else if (selectedOption == 'Arrived') {
                filteredDocuments = filteredDocuments
                    ?.where((doc) => doc['arrival_status'] == 1)
                    .toList();
              }
            });
          }

          final advisorDocuments = dashboardDetails.filterAdvisorDocuments(
              filteredDocuments,
              department ?? '',
              section ?? '',
              year ?? 0,
              college ?? '');
          final hodDocuments = dashboardDetails.filterHodDocuments(
              filteredDocuments, department ?? '', year ?? 0, college ?? '');
          final wardenDocuments = dashboardDetails.filterWardenDocuments(
              filteredDocuments, hostel ?? '');

          int advisorDepartCount = dashboardDetails
              .countDocumentsWithFieldValue(advisorDocuments, 'depart_status');
          int advisorArrivalCount = dashboardDetails
              .countDocumentsWithFieldValue(advisorDocuments, 'arrival_status');

          int hodDepartCount = dashboardDetails.countDocumentsWithFieldValue(
              hodDocuments, 'depart_status');
          int hodArrivalCount = dashboardDetails.countDocumentsWithFieldValue(
              hodDocuments, 'arrival_status');

          int wardenDepartCount = dashboardDetails.countDocumentsWithFieldValue(
              wardenDocuments, 'depart_status');
          int wardenArrivalCount = dashboardDetails
              .countDocumentsWithFieldValue(wardenDocuments, 'arrival_status');

          return SafeArea(
            child: RefreshIndicator(
              backgroundColor: Theme.of(context).colorScheme.primary,
              color: Colors.white,
              onRefresh: () async {
                await dashboardDetails.fetchAllInfo(context);
                await Future.delayed(const Duration(seconds: 1));
                setState(() {});
              },
              // ignore: deprecated_member_use
              child: WillPopScope(
                onWillPop: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                  return false;
                },
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 60,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    automaticallyImplyLeading: false,
                    title: const Text(
                      "Outpass Dashboard",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    actions: [
                      if (isAdmin == 'yes' && !asAdmin)
                        IconButton(
                          onPressed: () async {
                            bool? confirm = await showConfirmationDialog(
                                context, adminMessage);
                            if (confirm != null && confirm) {
                              setState(() {
                                filteredDocuments = widget.documents;
                                asAdmin = true;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.admin_panel_settings,
                            size: 30,
                          ),
                        ),
                      if (!asAdmin)
                        FilterOptions(
                          onOptionSelected: (selectedOption) {
                            onFilterOptionSelected(selectedOption);
                          },
                          position: position ?? '',
                        ),
                      if (asAdmin)
                        IconButton(
                            onPressed: () async {
                              bool? confirm = await showConfirmationDialog(
                                  context, downloadMsg);
                              if (confirm != null && confirm) {
                                ExcelGenerator generator = ExcelGenerator();
                                generator.requestPermission(context);
                              }
                            },
                            icon: const Icon(
                              Icons.download_rounded,
                              size: 30,
                            ))
                    ],
                  ),
                  body: ListView(
                    padding: const EdgeInsets.all(15),
                    children: [
                      position == 'Class Advisor'
                          ? AdvisorDashboardCounter(
                              countOne: advisorDepartCount,
                              countTwo: advisorArrivalCount)
                          : position == 'HoD'
                              ? HodDashboardCounter(
                                  countOne: hodDepartCount,
                                  countTwo: hodArrivalCount)
                              : WardenDashboardCounter(
                                  countOne: wardenDepartCount,
                                  countTwo: wardenArrivalCount),
                      const SizedBox(
                        height: 30,
                      ),
                      position == 'Class Advisor'
                          ? DashboardTable(documents: advisorDocuments)
                          : position == 'HoD'
                              ? DashboardTable(documents: hodDocuments)
                              : DashboardTable(documents: wardenDocuments),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
