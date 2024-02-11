// ignore_for_file: use_build_context_synchronously, avoid_print, unused_local_variable

import 'imports.dart';

class ExcelGenerator {

  Future<void> requestPermission(BuildContext context) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      generateCSV(context);
    } else {
      print("Permission denied. Unable to save the file.");
    }
  }

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
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
        );
      },
    );
  }

  static void showFinishDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
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
        );
      },
    );
  }

  static void showLoadingDialog() {
    const Dialog(
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
              "Saving the Excel file ...",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _generateCSVData(List<QueryDocumentSnapshot> docs) {
    List<List<dynamic>> rows = [];

    // Add header row
    rows.add([
      'Name',
      'Register No',
      'Depart Date',
      'Depart Time',
      'Arrival Date',
      'Arrival Time',
      'Email',
      'Year',
      'Department',
      'Section',
      'Hostel',
      'Room No',
      'Student Mobile',
      'Parent Mobile',
    ]);

    // Add data rows
    for (QueryDocumentSnapshot doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      rows.add([
        data['name'] ?? '',
        data['register_no'] ?? '',
        data['depart_date'] ?? '',
        data['depart_time'] ?? '',
        data['arrival_date'] ?? '',
        data['arrival_time'] ?? '',
        data['email'] ?? '',
        data['year'].toString(),
        data['department'] ?? '',
        data['section'] ?? '',
        data['hostel'] ?? '',
        data['room_no'] ?? '',
        data['student_mobile'].toString(),
        data['parent_mobile'].toString(),
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }


  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> generateCSV(BuildContext context) async {
    try {
      showLoadingDialog();
      print("Fetching the documents from the online database ...");
      QuerySnapshot querySnapshot = await firestore.collection('dashboard')
        .where(FieldPath.documentId, isNotEqualTo: 'sample-document')
        .where('arrival_status', isEqualTo: 1)
        .get();

      String csvData = _generateCSVData(querySnapshot.docs);

      print("Getting the file path location to save the file ...");
      String dir = "${(await getExternalStorageDirectory())!.path}/Outpass_Data_${_getCurrentDateAndTime()}.csv";

      print("Saving the file in the mobile device ...");
      final File file = File(dir);
      await file.writeAsString(csvData);
      if (await Permission.storage.isGranted && await file.exists()) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          await documentSnapshot.reference.delete();
        }
        Navigator.pop(context);
        showFinishDialog(context, 'File saved successfully.');
      } else {
        showErrorDialog(context, 'Sorry, the file does not exist.');
      }
    } catch (e) {
      print(e.toString());
      showErrorDialog(context, 'Sorry, an error occured while fetching data from database.');
    }
  }

  String _getCurrentDateAndTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy_HH:mm').format(now);
    return formattedDate;
  }

}
