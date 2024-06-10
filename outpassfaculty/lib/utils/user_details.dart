// ignore_for_file: use_build_context_synchronously, avoid_print

import 'imports.dart';

class UserDetails {
  static void showErrorDialog(BuildContext context) {
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
                const Text(
                  "Currently, no students submitted outpass.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
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

  void passValuesToPage(BuildContext context,
      List<QueryDocumentSnapshot<Map<dynamic, dynamic>>>? outpassList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmissionPage(outpassList: outpassList),
      ),
    );
  }

  // Method to fetch the details of the faculty.
  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> getUserDetails(
      String userEmail) async {
    final userCollection = FirebaseFirestore.instance.collection('faculty');

    final userQuery =
        await userCollection.where('email', isEqualTo: userEmail).get();

    return userQuery.docs.isNotEmpty ? userQuery.docs.first : null;
  }

  // Method to fetch the document_id of the student document.
  Future<String> getStudentDocumentId(String registerNo) async {
    final userCollection = FirebaseFirestore.instance.collection('users');

    final userQuery =
        await userCollection.where('register_no', isEqualTo: registerNo).get();

    return userQuery.docs.isNotEmpty ? userQuery.docs.first.id : '';
  }

  // Method to fetch all the required details of a faculty.
  Future<List<QueryDocumentSnapshot<Map<dynamic, dynamic>>>> fetchAllInfo(
      BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? currentUserEmail = user!.email;
    final userDocument = await getUserDetails(currentUserEmail!);
    if (userDocument != null) {
      final userData = userDocument.data();
      String? position = userData['position'];
      int? year = userData['year'];
      String? department = userData['department'];
      String? section = userData['section'];
      String? hostel = userData['hostel'];
      print('Details of the faculty: $position, $year,  $department, $section');
      List<QueryDocumentSnapshot<Map<dynamic, dynamic>>>? outpassList =
          await getStudentOutpass(position, year, department, section, hostel);
      if (outpassList != null && outpassList != [] && outpassList.isNotEmpty) {
        passValuesToPage(context, outpassList);
      } else {
        showErrorDialog(context);
      }
    } else {
      print('ALERT: User details not found.');
      return [];
    }

    return [userDocument];
  }

  // Fetch all the outpass details of the students.
  Future<List<QueryDocumentSnapshot<Map<dynamic, dynamic>>>?> getStudentOutpass(
      String? position,
      int? year,
      String? department,
      String? section,
      String? hostel) async {
    final userCollection = FirebaseFirestore.instance.collection('users');

    QuerySnapshot<Map<dynamic, dynamic>> userQuery;

    if (position == 'Class Advisor') {
      userQuery = await userCollection
          .where(
            'year',
            isEqualTo: year,
          )
          .where(
            'department',
            isEqualTo: department,
          )
          .where(
            'section',
            isEqualTo: section,
          )
          .where(
            'advisor_status',
            isEqualTo: 0,
          )
          .where(
            'warden_status',
            isNotEqualTo: -1,
          )
          .orderBy('submit_date')
          .get();
    } else if (position == 'HoD') {
      QuerySnapshot<Map<String, dynamic>> query;
      if (year != null && year == 1) {
        query = await userCollection
            .where(
              'year',
              isEqualTo: year,
            )
            .where(
              'advisor_status',
              isEqualTo: 1,
            )
            .where(
              'hod_status',
              isEqualTo: 0,
            )
            .where(
              'warden_status',
              isNotEqualTo: -1,
            )
            .get();
      } else {
        query = await userCollection
            .where(
              'year',
              isNotEqualTo: 1,
            )
            .where(
              'department',
              isEqualTo: department,
            )
            .where(
              'advisor_status',
              isEqualTo: 1,
            )
            .where(
              'hod_status',
              isEqualTo: 0,
            )
            .where(
              'warden_status',
              isNotEqualTo: -1,
            )
            .get();
      }
      userQuery = query;
    } else if (hostel != null && position == 'Warden') {
      userQuery = await userCollection
          .where(
            'hostel',
            isEqualTo: hostel,
          )
          .where(
            'warden_status',
            isEqualTo: 0,
          )
          .get();
    } else {
      return null;
    }
    return userQuery.docs.isNotEmpty ? userQuery.docs : null;
  }
}
