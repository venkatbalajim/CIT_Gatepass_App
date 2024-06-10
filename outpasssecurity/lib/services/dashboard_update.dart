// ignore_for_file: avoid_print, use_build_context_synchronously

import '../utils/imports.dart';

class Dashboard {
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

  static Future<void> updateDashboard(
      BuildContext context, String documentId) async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    try {
      final userQuery = await userCollection.doc(documentId).get();
      Map<String, dynamic>? studentDetail = userQuery.data();

      if (studentDetail != null) {
        final dashboardCollection =
            FirebaseFirestore.instance.collection('dashboard');
        await dashboardCollection
            .doc(documentId)
            .set(studentDetail, SetOptions(merge: true));
      } else {
        showErrorDialog(context, "Student not found.");
      }
    } catch (e) {
      print('Error updating dashboard: $e');
      showErrorDialog(context, "An error occurred while updating dashboard.");
    }
  }
}
