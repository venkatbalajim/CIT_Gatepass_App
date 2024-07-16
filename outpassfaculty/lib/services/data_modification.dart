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
    Navigator.pop(context);
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

    String name = rowData[0];
    String email = rowData[1];
    String college = rowData[2];
    String department = rowData[3];
    String section = rowData[4];
    String hostel = rowData[8];

    return {
      'name': name.trim().toUpperCase(),
      'email': email.trim(),
      'college': college.trim().toUpperCase(),
      'department': department.trim().toUpperCase(),
      'section': section.trim().toUpperCase(),
      'year': rowData[5],
      'student_mobile': rowData[6],
      'parent_mobile': rowData[7],
      'hostel': hostel.trim().toUpperCase(),
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
    Navigator.pop(context);
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

// Faculty database
class FacultyDatabase {
  Future<List<QueryDocumentSnapshot<Map<dynamic, dynamic>>>?>
      getFacultyData() async {
    final facultyCollection = FirebaseFirestore.instance.collection('faculty');
    QuerySnapshot<Map<dynamic, dynamic>> facultyData =
        await facultyCollection.where('position', isNotEqualTo: 'Warden').get();
    return facultyData.docs;
  }

  Map<String, dynamic> facultyMap(List<dynamic> data) {
    String name = data[1];
    String email = data[2];
    String college = data[3];
    String department = data[4];

    if (data[0] == "Class Advisor") {
      String section = data[6];

      return {
        'position': data[0],
        'name': name.trim().toUpperCase(),
        'email': email.trim(),
        'college': college.trim().toUpperCase(),
        'department': department.trim().toUpperCase(),
        'year': data[5],
        'section': section.trim().toUpperCase(),
        'fcm_token': "Unknown",
      };
    } else {
      return {
        'position': data[0],
        'name': name.trim().toUpperCase(),
        'email': email.trim(),
        'college': college.trim().toUpperCase(),
        'department': department.trim().toUpperCase(),
        'year': data[5],
        'fcm_token': "Unknown",
      };
    }
  }

  Future<void> addFacultyData(
      BuildContext context, Map<String, dynamic> newData) async {
    showLoadingDialog(context);
    try {
      final facultyCollection =
          FirebaseFirestore.instance.collection('faculty');
      await facultyCollection.add(newData);
      Navigator.pop(context);
      showFinishDialog(context, 'Faculty data is added successfully');
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog(
          context, 'Sorry, unable to add the data in the database.');
      print('Error deleting documents: $e');
    }
  }

  Future<void> updateFacultyData(
      BuildContext context, Map<String, dynamic> newData) async {
    showLoadingDialog(context);
    try {
      final facultyCollection =
          FirebaseFirestore.instance.collection('faculty');
      final document = await facultyCollection
          .where('email', isEqualTo: newData['email'])
          .get();
      if (document.docs.isNotEmpty) {
        await facultyCollection.doc(document.docs.first.id).update(newData);
        if (newData['position'] == "HoD") {
          await facultyCollection
              .doc(document.docs.first.id)
              .update({'section': FieldValue.delete()});
        }
        Navigator.pop(context);
        showFinishDialog(context, 'Faculty data is updated successfully');
      } else {
        Navigator.pop(context);
        showErrorDialog(
            context, 'There is no faculty data with this Email ID.');
      }
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog(
          context, 'Sorry, unable to update the data in the database.');
      print('Error deleting documents: $e');
    }
  }

  Future<void> deleteFacultyData(BuildContext context, String email) async {
    showLoadingDialog(context);
    try {
      CollectionReference facultyCollection =
          FirebaseFirestore.instance.collection('faculty');
      final document =
          await facultyCollection.where('email', isEqualTo: email).get();
      Navigator.pop(context);
      if (document.docs.isNotEmpty) {
        await facultyCollection.doc(document.docs.first.id).delete();
        showFinishDialog(context, 'Faculty data is deleted successfully');
      } else {
        showErrorDialog(
            context, 'There is no faculty data with this Email ID.');
      }
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog(
          context, 'Sorry, unable to delete the data in the database.');
      print('Error deleting documents: $e');
    }
  }
}

// Warden database
class WardenDatabase {
  Map<String, dynamic> wardenMap(List<dynamic> data) {
    String name = data[0];
    String email = data[1];
    String hostel = data[2];

    return {
      'position': "Warden",
      'name': name.trim().toUpperCase(),
      'email': email.trim(),
      'hostel': hostel.trim().toUpperCase(),
      'admin': data[3],
      'fcm_token': "Unknown",
    };
  }

  Future<List<QueryDocumentSnapshot<Map<dynamic, dynamic>>>?>
      getWardenData() async {
    final facultyCollection = FirebaseFirestore.instance.collection('faculty');
    QuerySnapshot<Map<dynamic, dynamic>> facultyData =
        await facultyCollection.where('position', isEqualTo: 'Warden').get();
    return facultyData.docs;
  }

  Future<void> addWardenData(
    BuildContext context,
    Map<String, dynamic> newData,
  ) async {
    showLoadingDialog(context);
    try {
      final wardenCollection = FirebaseFirestore.instance.collection('faculty');
      await wardenCollection.add(newData);
      Navigator.pop(context);
      showFinishDialog(context, 'Warden data is added successfully');
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog(
          context, 'Sorry, unable to add the data in the database.');
      print('Error deleting documents: $e');
    }
  }

  Future<void> updateWardenData(
      BuildContext context, Map<String, dynamic> newData) async {
    showLoadingDialog(context);
    try {
      final facultyCollection =
          FirebaseFirestore.instance.collection('faculty');
      final document = await facultyCollection
          .where('email', isEqualTo: newData['email'])
          .get();
      if (document.docs.isNotEmpty) {
        await facultyCollection.doc(document.docs.first.id).update(newData);
        Navigator.pop(context);
        showFinishDialog(context, 'Warden data is updated successfully');
      } else {
        Navigator.pop(context);
        showErrorDialog(context, 'There is no warden data with this Email ID.');
      }
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog(
          context, 'Sorry, unable to update the data in the database.');
      print('Error deleting documents: $e');
    }
  }

  Future<void> deleteWardenData(BuildContext context, String email) async {
    showLoadingDialog(context);
    try {
      CollectionReference facultyCollection =
          FirebaseFirestore.instance.collection('faculty');
      final document =
          await facultyCollection.where('email', isEqualTo: email).get();
      Navigator.pop(context);
      if (document.docs.isNotEmpty) {
        await facultyCollection.doc(document.docs.first.id).delete();
        showFinishDialog(context, 'Warden data is deleted successfully');
      } else {
        showErrorDialog(context, 'There is no warden data with this Email ID.');
      }
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog(
          context, 'Sorry, unable to delete the data in the database.');
      print('Error deleting documents: $e');
    }
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
