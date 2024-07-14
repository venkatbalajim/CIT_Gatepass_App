// ignore_for_file: use_build_context_synchronously, avoid_print

import 'imports.dart';

class DashboardDetails {
  static void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(15),
            width: 250,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Currently, no students data are available in the dashboard, if you want expired outpass history, kindly contact warden.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
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

  // Method to fetch all the documents in 'dashboard' collection.
  Future<void> fetchAllInfo(BuildContext context) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String? currentUserEmail = user!.email;
      UserDetails userDetails = UserDetails();
      String position = '';
      final userDocument = await userDetails.getUserDetails(currentUserEmail!);
      final userData = userDocument?.data();
      if (userData != null) {
        position = userData['position'];
      } else {
        print('Error fetching data');
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('dashboard')
          .orderBy('depart_date')
          .orderBy('depart_time')
          .orderBy('name')
          .get();
      List<DocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs.cast<DocumentSnapshot<Map<String, dynamic>>>();
      if (documents.isNotEmpty && documents != []) {
        passValuesToPage(context, documents, position);
      } else if (position == "Principal") {
        passValuesToPage(context, documents, position);
      } else {
        showErrorDialog(context);
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  // Method to pass the fetched documents to the dashboard page.
  void passValuesToPage(BuildContext context,
      List<DocumentSnapshot<Map<String, dynamic>>> documents, String position) {
    try {
      if (position == 'Principal') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PrincipalPage(documents: documents),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(documents: documents),
          ),
        );
      }
    } catch (error) {
      print('Error navigating to DashBoardPage: $error');
    }
  }

  // Method to filter the documents related to Class Advisors.
  List<DocumentSnapshot<Map<String, dynamic>>> filterAdvisorDocuments(
      List<DocumentSnapshot<Map<String, dynamic>>>? allDocuments,
      String depart,
      String section,
      int year,
      String college) {
    if (allDocuments == null) {
      return [];
    }
    return allDocuments.where((doc) {
      final userData = doc.data();
      return userData!['department'] == depart &&
          userData['section'] == section &&
          userData['year'] == year &&
          userData['college'] == college;
    }).toList();
  }

  // Method to filter the documents related to HoD.
  List<DocumentSnapshot<Map<String, dynamic>>> filterHodDocuments(
      List<DocumentSnapshot<Map<String, dynamic>>>? allDocuments,
      String depart,
      int year,
      String college) {
    if (allDocuments == null) {
      return [];
    } else if (year == 1) {
      return allDocuments.where((doc) {
        final userData = doc.data();
        return userData!['college'] == college && userData['year'] == 1;
      }).toList();
    } else {
      return allDocuments.where((doc) {
        final userData = doc.data();
        return userData!['department'] == depart &&
            userData['year'] != 1 &&
            userData['college'] == college;
      }).toList();
    }
  }

  // Method to filter the documents related to Wardens.
  List<DocumentSnapshot<Map<String, dynamic>>> filterWardenDocuments(
    List<DocumentSnapshot<Map<String, dynamic>>>? allDocuments,
    String hostel,
  ) {
    if (allDocuments == null) {
      return [];
    }
    return allDocuments.where((doc) {
      final userData = doc.data();
      return userData!['hostel'] == hostel;
    }).toList();
  }

  // Method to separate the documents who are not yet arrived.
  List<DocumentSnapshot<Map<String, dynamic>>> notYetArrivedDocuments(
      List<DocumentSnapshot<Map<String, dynamic>>>? allDocuments) {
    return allDocuments!.where((doc) {
      final userData = doc.data();
      return userData!['arrival_status'] == 0;
    }).toList();
  }

  // Method to count the documents with the specified value.
  int countDocumentsWithFieldValue(
      List<DocumentSnapshot<Map<String, dynamic>>>? documents,
      String fieldName) {
    int count = 0;
    if (documents != null) {
      for (var document in documents) {
        final data = document.data();
        if (data![fieldName] == 1) {
          count++;
        }
      }
    }
    return count;
  }

  int countBasedOnHostelName(
      List<DocumentSnapshot<Map<String, dynamic>>>? documents,
      String hostelName,
      String fieldName) {
    int count = 0;
    if (documents != null) {
      for (var document in documents) {
        final data = document.data();
        if (data!['hostel'] == hostelName && data[fieldName] == 1) {
          count++;
        }
      }
    }
    return count;
  }

  int countBasedOnDepartment(
      List<DocumentSnapshot<Map<String, dynamic>>>? documents,
      String department,
      String fieldName) {
    int count = 0;
    if (documents != null) {
      for (var document in documents) {
        final data = document.data();
        if (data!['department'] == department && data[fieldName] == 1) {
          count++;
        }
      }
    }
    return count;
  }
}
