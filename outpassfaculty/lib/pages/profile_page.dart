import '../../utils/imports.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                    fontSize: 18,
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

  String msg =
      "Note: If any of your information is incorrect, kindly contact the warden.";

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? currentUserEmail = user!.email;

    UserDetails userDetail = UserDetails();

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
      future: userDetail.getUserDetails(currentUserEmail!),
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
          final userData = snapshot.data?.data();

          Widget pageBody(String? email) {
            if (email != null) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Faculty Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber[100]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Account Information',
                              style: TextStyle(
                                  color: Colors.amber[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          const SizedBox(height: 10),
                          InfoCard(
                              label: "Email ID", detail: userData?['email']),
                        ],
                      )),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.amber[100]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Faculty Information',
                            style: TextStyle(
                                color: Colors.amber[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        const SizedBox(height: 10),
                        InfoCard(label: "Name", detail: userData?['name']),
                        InfoCard(
                            label: "Position", detail: userData?['position']),
                        if (userData?['position'] == 'Class Advisor' ||
                            userData?['position'] == 'HoD')
                          InfoCard(
                              label: "College", detail: userData?['college']),
                        if (userData?['position'] == 'Class Advisor')
                          InfoCard(label: "Year", detail: userData?['year']),
                        if (userData?['position'] != 'Warden')
                          InfoCard(
                              label: "Department",
                              detail: userData?['department']),
                        if (userData?['position'] == 'Warden')
                          InfoCard(
                              label: 'Hostel', detail: userData?['hostel']),
                        if (userData?['position'] == 'Warden')
                          InfoCard(
                              label: 'Admin',
                              detail:
                                  userData?['admin'] == 'yes' ? "Yes" : "No"),
                        if (userData?['position'] == 'Class Advisor')
                          InfoCard(
                              label: "Section", detail: userData?['section']),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Text(
                    textAlign: TextAlign.center,
                    'Sorry, unable to load the page.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
              );
            }
          }

          return SafeArea(
            child: Scaffold(body: pageBody(userData!['email'])),
          );
        }
      },
    );
  }
}
