import '../utils/imports.dart';

class SubmissionPage extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<dynamic, dynamic>>>? outpassList;
  const SubmissionPage({super.key, this.outpassList});

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  UserDetails userDetails = UserDetails();

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
                      }),
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

          return SafeArea(
              child: RefreshIndicator(
            backgroundColor: Theme.of(context).colorScheme.primary,
            color: Colors.white,
            onRefresh: () async {
              await userDetails.fetchAllInfo(context);
              await Future.delayed(const Duration(seconds: 1));
              setState(() {});
            },
            // ignore: deprecated_member_use
            child: WillPopScope(
                onWillPop: () async {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                  return true;
                },
                child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      title: Text(
                        "Students Outpass Submission",
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    body:
                        ListView(padding: const EdgeInsets.all(10), children: [
                      position == 'Class Advisor'
                          ? ClassAdvisorSubmissionContainer(
                              outpassList: widget.outpassList,
                            )
                          : position == 'HoD'
                              ? HodSubmissionContainer(
                                  outpassList: widget.outpassList,
                                )
                              : WardenSubmissionContainer(
                                  outpassList: widget.outpassList),
                    ]))),
          ));
        }
      },
    );
  }
}
