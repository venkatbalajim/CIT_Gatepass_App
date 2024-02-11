import '../utils/imports.dart';

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

  String msg = "Note: If any of your information is incorrect, kindly contact the warden.";

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
              ),
            ),
          );
        } else if (snapshot.hasError) {
          showErrorDialog(context, "Sorry, an error occured. Please try later.");
          return const SizedBox();
        } else {

          final userData = snapshot.data?.data();

          return SafeArea(
            child: Scaffold(
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 10),
                  Text("User Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InstructionCard(instruction: msg),
                  const SizedBox(height: 20,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InfoCard(label: "Name", detail: userData?['name']),
                        InfoCard(label: "Register No", detail: userData?['register_no']),
                        InfoCard(label: "Email ID", detail: userData?['email']),
                        InfoCard(label: "Department", detail: userData?['department']),
                        InfoCard(label: "Year", detail: userData?['year']),
                        InfoCard(label: "Section", detail: userData?['section']),
                        InfoCard(label: "Student Mobile No", detail: userData?['student_mobile']),
                        InfoCard(label: "Parent Mobile No", detail: userData?['parent_mobile']),
                        InfoCard(label: "Hostel", detail: userData?['hostel']),
                        InfoCard(label: "Room No", detail: userData?['room_no']),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 150,
                      height: 40,
                      child: SmallButton(name: 'Go to Home', onTap: () {
                        Navigator.popUntil(context, (route) => route.settings.name == '/options');
                      }),
                    ),
                  ),
                  const SizedBox(height: 30,),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
