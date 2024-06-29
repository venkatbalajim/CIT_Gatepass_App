// ignore_for_file: avoid_print, depend_on_referenced_packages, use_build_context_synchronously, deprecated_member_use

import '../utils/imports.dart';

// Add all students data at once
class AddStudentsData {
  final String filePath;

  AddStudentsData(this.filePath);

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
            context, 'Data added successfully. Check the database.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addData(
      BuildContext context, Map<String, dynamic> newData) async {
    showLoadingDialog(context);
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await usersCollection.where('email', isEqualTo: newData['email']).get();
    if (querySnapshot.docs.isNotEmpty) {
      Navigator.pop(context);
      CustomSnackBar.showSnackBar(context,
          'The student data linked with this Email ID is already exist.');
      return;
    }
    await usersCollection.add(newData);
    showFinishDialog(context, 'Data added successfully. Check the database.');
  }

  Future<void> updateData(
      BuildContext context, Map<String, dynamic> newData) async {
    showLoadingDialog(context);
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await usersCollection.where('email', isEqualTo: newData['email']).get();
    await querySnapshot.docs.first.reference.update(newData);
    Navigator.pop(context);
    showFinishDialog(context, 'Data updated successfully. Check the database.');
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

// Students database
class StudentsDatabase {
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int? version = int.tryParse(androidInfo.version.release);
      if (version != null && version <= 12) {
        PermissionStatus status1 = await Permission.storage.request();
        return status1 == PermissionStatus.granted;
      } else {
        PermissionStatus status2 =
            await Permission.manageExternalStorage.request();
        return status2 == PermissionStatus.granted;
      }
    } else if (Platform.isIOS) {
      PermissionStatus status = await Permission.storage.request();
      return (status == PermissionStatus.granted ||
          status == PermissionStatus.limited);
    } else {
      return false;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<dynamic, dynamic>>>?>
      getStudentsData() async {
    final studentsCollection = FirebaseFirestore.instance.collection('users');
    QuerySnapshot<Map<dynamic, dynamic>> studentsData =
        await studentsCollection.get();
    return studentsData.docs;
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
