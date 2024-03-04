// ignore_for_file: avoid_print, depend_on_referenced_packages, use_build_context_synchronously, deprecated_member_use

import '../utils/imports.dart';

Future<void> deleteAllDocuments(BuildContext context) async {
  UploadStudentData.showLoadingDialog(context);
  try {
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

    QuerySnapshot querySnapshot = await usersCollection.get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      await document.reference.delete();
    }

    Navigator.pop(context);
    UploadStudentData.showFinishDialog(context, 'All the students data are successfully deleted. Check the database.');
    print('All documents in the "users" collection have been deleted.');
  } catch (e) {
    UploadStudentData.showErrorDialog(context, 'Sorry, unable to delete the data in the database.');
    print('Error deleting documents: $e');
  }
}

class UploadStudentData{
  final String filePath;

  UploadStudentData(this.filePath);

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
        CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

        for (int i = 1; i < csvData.length; i++) {
          List<dynamic> rowData = csvData[i];
          Map<String, dynamic> userData = createCustomMap(rowData, context);

          QuerySnapshot querySnapshot = await usersCollection.where('email', isEqualTo: userData['email']).get();

          if (querySnapshot.docs.isNotEmpty) {
            await querySnapshot.docs.first.reference.update(userData);
          } else {
            await usersCollection.add(userData);
          }
        }
        Navigator.pop(context);
        showFinishDialog(context, 'Data uploaded successfully. Check the database.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Map<String, dynamic> createCustomMap(List<dynamic> rowData, BuildContext context) {
    if (rowData.length < 10) {
      showErrorDialog(context, 'ALERT: Some student data is missing in the CSV file.');
      throw ArgumentError('Invalid number of elements in the rowData list.');
    }

    return {
      'name': rowData[0],
      'email': rowData[1],
      'register_no': rowData[2],
      'department': rowData[3],
      'section': rowData[4],
      'year': rowData[5],
      'student_mobile': rowData[6],
      'parent_mobile': rowData[7],
      'hostel': rowData[8],
      'room_no': rowData[9],
      'fcm_token': 'Unknown'
    };
  }

  static void showErrorDialog(BuildContext context, String message) {
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

  static void showFinishDialog(BuildContext context, String message) {
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
                        Navigator.popUntil(context, (route) => route.settings.name == '/options');
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

  static void showLoadingDialog(BuildContext context) {
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
                    "Uploading the data. This may take some time.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
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

}
