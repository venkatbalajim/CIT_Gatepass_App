// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_nullable, non_constant_identifier_names, constant_identifier_names
import '../utils/imports.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static const Error_Message_1 =
      "Sorry, something went wrong. Please try again.";
  static const Error_Message_2 =
      "Sorry, this is unauthorized Gmail account. Kindly use Gmail provided by the college.";

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          child: Container(
            width: 250,
            height: 200,
            alignment: Alignment.center,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showErrorDialog(BuildContext context, String message) {
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
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 100,
                  child: SmallButton(
                    onTap: () {
                      Navigator.pop(context);
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

  static Future<String?> signInwithGoogle(BuildContext context) async {
    try {
      showLoadingDialog(context);

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        final String? userEmail = userCredential.user?.email;
        if (userEmail != null) {
          final QuerySnapshot<Map<String, dynamic>> userSnapshot =
              await FirebaseFirestore.instance
                  .collection('faculty')
                  .where('email', isEqualTo: userEmail)
                  .get();

          if (userSnapshot.docs.isNotEmpty) {
            await FirebaseMessagingService().initNotifications();
            Navigator.pop(context);
            final userData = userSnapshot.docs.first.data();
            final position = userData['position'];
            if (position == "Principal") {
              DashboardDetails dashboardDetails = DashboardDetails();
              await dashboardDetails.fetchAllInfo(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            }
          } else {
            await _googleSignIn.signOut();
            await _auth.currentUser?.delete();
            Navigator.pop(context);
            showErrorDialog(context, Error_Message_2);
          }
        } else {
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
      }
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorDialog(context, Error_Message_1);
    }
  }

  static Future<void> signOutFromGoogle(BuildContext context) async {
    try {
      showLoadingDialog(context);
      await _googleSignIn.signOut();
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ),
      );
    } catch (error) {
      Navigator.pop(context);
      showErrorDialog(context, Error_Message_1);
    }
  }
}
