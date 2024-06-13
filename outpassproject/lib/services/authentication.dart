// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_nullable, non_constant_identifier_names, constant_identifier_names
import '../utils/imports.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static const Error_Message_1 =
      "Sorry, something went wrong. Please try again.";
  static const Error_Message_2 =
      "Sorry, this is unauthorized Email ID. Kindly use the college Email ID.";

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
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const Text('Permission Denied'),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          actions: [
            Theme(
                data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    )))
          ],
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
                  .collection('users')
                  .where('email', isEqualTo: userEmail)
                  .get();

          if (userSnapshot.docs.isNotEmpty) {
            await FirebaseMessagingService().initNotifications();
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const WelcomePage()));
    } catch (error) {
      Navigator.pop(context);
      showErrorDialog(context, Error_Message_1);
    }
  }
}
