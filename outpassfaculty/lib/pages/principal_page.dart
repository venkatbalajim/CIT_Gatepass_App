import '../utils/imports.dart';

class PrincipalPage extends StatefulWidget {
  final List<DocumentSnapshot<Map<String, dynamic>>>? documents;
  const PrincipalPage({super.key, this.documents});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  bool _backButtonPressedOnce = false;
  DateTime? _lastBackPressed;
  UserDetails userDetails = UserDetails();
  DashboardDetails dashboardDetails = DashboardDetails();

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? currentUserEmail = user!.email;

    void showErrorDialog(BuildContext context, String message) {
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
            int overallDepartCount =
                dashboardDetails.countDocumentsWithFieldValue(
                    widget.documents, 'depart_status');
            int overallArrivalCount =
                dashboardDetails.countDocumentsWithFieldValue(
                    widget.documents, 'arrival_status');

            int pothigaiDepartCount = dashboardDetails.countBasedOnHostelName(
                widget.documents, 'Pothigai', 'depart_status');
            int pothigaiArrivalCount = dashboardDetails.countBasedOnHostelName(
                widget.documents, 'Pothigai', 'arrival_status');

            int thamirabharaniDepartCount =
                dashboardDetails.countBasedOnHostelName(
                    widget.documents, 'Thamirabharani', 'depart_status');
            int thamirabharaniArrivalCount =
                dashboardDetails.countBasedOnHostelName(
                    widget.documents, 'Thamirabharani', 'arrival_status');

            int vaigaiDepartCount = dashboardDetails.countBasedOnHostelName(
                widget.documents, 'Vaigai', 'depart_status');
            int vaigaiArrivalCount = dashboardDetails.countBasedOnHostelName(
                widget.documents, 'Vaigai', 'arrival_status');

            int kaveriDepartCount = dashboardDetails.countBasedOnHostelName(
                widget.documents, 'Kaveri', 'depart_status');
            int kaveriArrivalCount = dashboardDetails.countBasedOnHostelName(
                widget.documents, 'Kaveri', 'arrival_status');

            int palarDepartCount = dashboardDetails.countBasedOnHostelName(
                widget.documents, 'Palar', 'depart_status');
            int palarArrivalCount = dashboardDetails.countBasedOnHostelName(
                widget.documents, 'Palar', 'arrival_status');

            int? aidsDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'AIDS', 'depart_status');
            int? aidsArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'AIDS', 'arrival_status');

            int? aimlDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'AIML', 'depart_status');
            int? aimlArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'AIML', 'arrival_status');

            int? bmeDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'BME', 'depart_status');
            int? bmeArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'BME', 'arrival_status');

            int? czDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'CZ', 'depart_status');
            int? czArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'CZ', 'arrival_status');

            int? cseDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'CSE', 'depart_status');
            int? cseArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'CSE', 'arrival_status');

            int? csbsDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'CSBS', 'depart_status');
            int? csbsArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'CSBS', 'arrival_status');

            int? eceDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'ECE', 'depart_status');
            int? eceArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'ECE', 'arrival_status');

            int? eeeDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'EEE', 'depart_status');
            int? eeeArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'EEE', 'arrival_status');

            int? mctDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'MCT', 'depart_status');
            int? mctArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'MCT', 'arrival_status');

            int? mechDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'MECH', 'depart_status');
            int? mechArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'MECH', 'arrival_status');

            int? cvlDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'CVL', 'depart_status');
            int? cvlArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'CVL', 'arrival_status');

            int? itDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'IT', 'depart_status');
            int? itArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'IT', 'arrival_status');

            int? actDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'ACT', 'depart_status');
            int? actArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'ACT', 'arrival_status');

            int? vlsiDepartCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'VLSI', 'depart_status');
            int? vlsiArrivalCount = dashboardDetails.countBasedOnDepartment(
                widget.documents, 'VLSI', 'arrival_status');

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
                    if (_backButtonPressedOnce) {
                      SystemNavigator.pop();
                      return false;
                    } else {
                      CustomSnackBar.showSnackBar(
                          context, "Press again to exit app");
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
                  child: Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 60,
                      surfaceTintColor: Colors.transparent,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      automaticallyImplyLeading: false,
                      title: const Text(
                        "Outpass Dashboard",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              FirebaseService.signOutFromGoogle(context);
                            },
                            icon: const Icon(
                              Icons.logout,
                              size: 30,
                            ))
                      ],
                    ),
                    body: ListView(
                      padding: const EdgeInsets.all(15),
                      children: [
                        Text(
                          "Overall Count",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PrincipalDashboardCounter(
                            countOne: overallDepartCount,
                            countTwo: overallArrivalCount),
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Based on Hostel",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        HostelCounterCard(
                            hostelName: 'Pothigai',
                            departCount: pothigaiDepartCount.toString(),
                            arrivalCount: pothigaiArrivalCount.toString()),
                        const SizedBox(
                          height: 10,
                        ),
                        HostelCounterCard(
                            hostelName: 'Thamirabharani',
                            departCount: thamirabharaniDepartCount.toString(),
                            arrivalCount:
                                thamirabharaniArrivalCount.toString()),
                        const SizedBox(
                          height: 10,
                        ),
                        HostelCounterCard(
                            hostelName: 'Vaigai',
                            departCount: vaigaiDepartCount.toString(),
                            arrivalCount: vaigaiArrivalCount.toString()),
                        const SizedBox(
                          height: 10,
                        ),
                        HostelCounterCard(
                            hostelName: 'Kaveri',
                            departCount: kaveriDepartCount.toString(),
                            arrivalCount: kaveriArrivalCount.toString()),
                        const SizedBox(
                          height: 10,
                        ),
                        HostelCounterCard(
                            hostelName: 'Palar',
                            departCount: palarDepartCount.toString(),
                            arrivalCount: palarArrivalCount.toString()),
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Based on Department",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'AIDS',
                          departCount: aidsDepartCount.toString(),
                          arrivalCount: aidsArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'AIML',
                          departCount: aimlDepartCount.toString(),
                          arrivalCount: aimlArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'BME',
                          departCount: bmeDepartCount.toString(),
                          arrivalCount: bmeArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'CSE',
                          departCount: cseDepartCount.toString(),
                          arrivalCount: cseArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'CSBS',
                          departCount: csbsDepartCount.toString(),
                          arrivalCount: csbsArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'CVL',
                          departCount: cvlDepartCount.toString(),
                          arrivalCount: cvlArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'CZ',
                          departCount: czDepartCount.toString(),
                          arrivalCount: czArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'ECE',
                          departCount: eceDepartCount.toString(),
                          arrivalCount: eceArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'EEE',
                          departCount: eeeDepartCount.toString(),
                          arrivalCount: eeeArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'MCT',
                          departCount: mctDepartCount.toString(),
                          arrivalCount: mctArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'MECH',
                          departCount: mechDepartCount.toString(),
                          arrivalCount: mechArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'IT',
                          departCount: itDepartCount.toString(),
                          arrivalCount: itArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'ACT',
                          departCount: actDepartCount.toString(),
                          arrivalCount: actArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DepartmentCounterCard(
                          deptName: 'VLSI',
                          departCount: vlsiDepartCount.toString(),
                          arrivalCount: vlsiArrivalCount.toString(),
                          documents: widget.documents,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
