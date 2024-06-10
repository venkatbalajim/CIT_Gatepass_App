// ignore_for_file: use_build_context_synchronously, avoid_print

import '../utils/imports.dart';

class UserDetails {
  // Method to fetch the details of the student.
  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> getUserDetails(
      String userEmail) async {
    final userCollection = FirebaseFirestore.instance.collection('users');

    final userQuery =
        await userCollection.where('email', isEqualTo: userEmail).get();

    return userQuery.docs.isNotEmpty ? userQuery.docs.first : null;
  }

  // Method to check whether arrival date time is before current date and time or not.
  TimeOfDay stringToTimeOfDay(String timeStr) {
    String timeSubstring =
        timeStr.substring(timeStr.indexOf('(') + 1, timeStr.indexOf(')'));
    List<String> parts = timeSubstring.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  bool isArrivalDateTimeBeforeCurrentDateTime(DateTime arrivalDateTime) {
    DateTime currentDateTime = DateTime.now();
    bool status = arrivalDateTime.isBefore(currentDateTime);
    print("Status is $status");
    return status;
  }

  // Method to check whether the student submitted an outpass already.
  Future<Widget> isSubmitted(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? currentUserEmail = user?.email;

    if (currentUserEmail != null) {
      final result = await getUserDetails(currentUserEmail);

      if (result!.exists) {
        final userData = result.data();
        final isSubmitted = userData['is_submitted'] ?? 0;
        QRValidation eraseData = QRValidation();

        if (isSubmitted == 0) {
          return const OutpassPage();
        } else if (isSubmitted == 1) {
          return const StatusPage();
        } else if (isSubmitted == 2) {
          final departStatus = userData['depart_status'];
          DateTime arrivalDate = DateTime.parse(userData['check_in_date']);
          TimeOfDay arrivalTime = stringToTimeOfDay(userData['check_in_time']);
          DateTime arrivalDateTime = DateTime(
              arrivalDate.year,
              arrivalDate.month,
              arrivalDate.day,
              arrivalTime.hour,
              arrivalTime.minute);
          if (departStatus == 0 &&
              isArrivalDateTimeBeforeCurrentDateTime(arrivalDateTime)) {
            eraseData.eraseAll(context);
            return const OutpassPage();
          } else {
            String docId = result.id;
            return QRPage(documentId: docId);
          }
        } else {
          return Center(
            child: Text(
              'Sorry, an error occured. Please come back later.',
              style: TextStyle(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          );
        }
      } else {
        return Center(
          child: Text(
            'Sorry, an error occured. Please come back later.',
            style: TextStyle(
                color: Colors.grey[900],
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        );
      }
    } else {
      return Center(
        child: Text(
          'Sorry, an error occured. Please come back later.',
          style: TextStyle(
              color: Colors.grey[900],
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
      );
    }
  }

  // Method to fetch the document_id of the student document.
  Future<String> getDocumentId(String userEmail) async {
    final userCollection = FirebaseFirestore.instance.collection('users');

    final userQuery =
        await userCollection.where('email', isEqualTo: userEmail).get();

    return userQuery.docs.isNotEmpty ? userQuery.docs.first.id : '';
  }
}
