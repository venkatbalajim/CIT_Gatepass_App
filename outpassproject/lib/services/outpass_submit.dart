// ignore_for_file: use_build_context_synchronously

import '../utils/imports.dart';

class FirestoreService {
  void showErrorDialog(BuildContext context, String message) {
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

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> saveOutpassDetails(
      BuildContext context, SaveOutpassDetails outpassDetails) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult != ConnectivityResult.none) {
        FirebaseAuth auth = FirebaseAuth.instance;
        User? user = auth.currentUser;
        String? currentUserEmail = user?.email;

        UserDetails userDetails = UserDetails();

        final result = await userDetails.getUserDetails(currentUserEmail!);

        if (result != null) {
          final userDocumentReference = result.reference;
          await userDocumentReference.update({
            'purpose': outpassDetails.purpose,
            'out_date': outpassDetails.outDate,
            'out_time': outpassDetails.outTime,
            'in_date': outpassDetails.inDate,
            'in_time': outpassDetails.inTime,
            'check_out_date': outpassDetails.checkOutDate.toString(),
            'check_out_time': outpassDetails.checkOutTime.toString(),
            'check_in_date': outpassDetails.checkInDate.toString(),
            'check_in_time': outpassDetails.checkInTime.toString(),
            'advisor_status': 0,
            'hod_status': 0,
            'warden_status': 0,
            'is_submitted': 1,
            'submit_date': outpassDetails.date,
          });
        }
      } else {
        showErrorDialog(context,
            "No internet connection. Please check your connection and try again.");
      }
    } catch (e) {
      showErrorDialog(context, "Something went wrong. Please try again later.");
    }
  }
}
