// ignore_for_file: avoid_print, depend_on_referenced_packages, use_build_context_synchronously, deprecated_member_use

import '../utils/imports.dart';

// Add all students data at once
class AddAllStudentsData {
  final String filePath;

  AddAllStudentsData(this.filePath);

  Future<List<List<dynamic>>> readCSVFile(File file) async {
    String csvString = file.readAsStringSync();
    List<List<dynamic>> csvData = const CsvToListConverter().convert(csvString);
    return csvData;
  }

  Future<File?> fetchCSVFile(BuildContext context) async {
    try {
      File file = File(filePath);
      if (await file.exists()) {
        print('Fetched file successfully');
        return file;
      }
      showErrorDialog(context, 'Sorry, unable to fetch the CSV file');
      return null;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> uploadData(BuildContext context) async {
    try {
      File? csvFile = await fetchCSVFile(context);
      if (csvFile != null) {
        showLoadingDialog(context);
        List<List<dynamic>> csvData = await readCSVFile(csvFile);
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');

        for (int i = 1; i < csvData.length; i++) {
          List<dynamic> rowData = csvData[i];
          Map<String, dynamic> userData = createCustomMap(rowData, context);

          QuerySnapshot querySnapshot = await usersCollection
              .where('email', isEqualTo: userData['email'])
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            await querySnapshot.docs.first.reference.update(userData);
          } else {
            await usersCollection.add(userData);
          }
        }
        Navigator.pop(context);
        showFinishDialog(
            context, 'Data uploaded successfully. Check the database.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Map<String, dynamic> createCustomMap(
      List<dynamic> rowData, BuildContext context) {
    if (rowData.length < 9) {
      showErrorDialog(
          context, 'ALERT: Some student data is missing in the CSV file.');
      throw ArgumentError('Invalid number of elements in the rowData list.');
    }

    return {
      'name': rowData[0],
      'email': rowData[1],
      'college': rowData[2],
      'department': rowData[3],
      'section': rowData[4],
      'year': rowData[5],
      'student_mobile': rowData[6],
      'parent_mobile': rowData[7],
      'hostel': rowData[8],
      'fcm_token': 'Unknown'
    };
  }
}

// Delete all students data at once
Future<void> deleteAllStudentsData(BuildContext context) async {
  showLoadingDialog(context);
  try {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot querySnapshot = await usersCollection.get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      await document.reference.delete();
    }

    Navigator.pop(context);
    showFinishDialog(context,
        'All the students data are successfully deleted. Check the database.');
    print('All documents in the "users" collection have been deleted.');
  } catch (e) {
    showErrorDialog(
        context, 'Sorry, unable to delete the data in the database.');
    print('Error deleting documents: $e');
  }
}

// Security database
class SecurityDatabase {
  Future<String> getSecurityPassword() async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('security');
      DocumentSnapshot document =
          await usersCollection.doc('security-information').get();

      if (document.exists) {
        var data = document.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('password')) {
          return data['password'] as String;
        } else {
          throw Exception('Password field is missing in the document');
        }
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      print('Error retrieving security password: $e');
      return "";
    }
  }

  void updatePassword(String password) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('security');
      DocumentReference<Object?> document =
          usersCollection.doc('security-information');
      document.update({'password': password});
    } catch (e) {
      print('Error retrieving security password: $e');
    }
  }
}

// Error Message Dialog
void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
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
                  width: 60,
                  child: SmallButton(
                    name: 'Ok',
                    onTap: () {
                      Navigator.pop(context);
                    },
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

// Finish Message Dialog
void showFinishDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
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
                  width: 60,
                  child: SmallButton(
                    name: 'Ok',
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
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

// Loading Indicator Dialog
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: const Dialog(
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
                  "This may take some time.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    },
  );
}
