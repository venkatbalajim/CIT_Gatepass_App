// ignore_for_file: avoid_print, use_build_context_synchronously

import '../utils/imports.dart';

class Validation {
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(
                        context, (route) => route.settings.name == '/scanner');
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

  static String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  static Future<void> updateStatus(
      BuildContext context, String documentId) async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    try {
      final userQuery = await userCollection.doc(documentId).get();
      Map<String, dynamic>? studentDetail = userQuery.data();
      if (studentDetail != null) {
        if (studentDetail['depart_status'] == 0) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(documentId)
              .update({
            'depart_status': 1,
            'depart_date': _formatDate(DateTime.now()),
            'depart_time': _formatTime(TimeOfDay.now()),
            'outpass_status': 'active',
          }).whenComplete(() async {
            await Dashboard.updateDashboard(context, documentId);
            Navigator.popUntil(
                context, (route) => route.settings.name == '/options');
          });
        } else if (studentDetail['depart_status'] == 1) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(documentId)
              .update({
            'arrival_status': 1,
            'arrival_date': _formatDate(DateTime.now()),
            'arrival_time': _formatTime(TimeOfDay.now()),
            'outpass_status': 'expired',
          }).whenComplete(() async {
            await Dashboard.updateDashboard(context, documentId);
          });
          await FirebaseFirestore.instance
              .collection('users')
              .doc(documentId)
              .update({
            'submit_date': FieldValue.delete(),
            'purpose': FieldValue.delete(),
            'out_date': FieldValue.delete(),
            'out_time': FieldValue.delete(),
            'in_date': FieldValue.delete(),
            'in_time': FieldValue.delete(),
            'advisor_status': FieldValue.delete(),
            'hod_status': FieldValue.delete(),
            'warden_status': FieldValue.delete(),
            'is_submitted': FieldValue.delete(),
            'arrival_status': FieldValue.delete(),
            'depart_status': FieldValue.delete(),
            'check_out_date': FieldValue.delete(),
            'check_out_time': FieldValue.delete(),
            'check_in_date': FieldValue.delete(),
            'check_in_time': FieldValue.delete(),
            'outpass_status': FieldValue.delete(),
            'depart_date': FieldValue.delete(),
            'depart_time': FieldValue.delete(),
            'arrival_date': FieldValue.delete(),
            'arrival_time': FieldValue.delete(),
          }).whenComplete(() {
            Navigator.popUntil(
                context, (route) => route.settings.name == '/options');
          });
        }
      } else {
        showErrorDialog(
            context, "User not found with the specified register number.");
      }
    } catch (e) {
      print('Error updating status: $e');
      showErrorDialog(context, "An error occurred while updating status.");
    }
  }
}
