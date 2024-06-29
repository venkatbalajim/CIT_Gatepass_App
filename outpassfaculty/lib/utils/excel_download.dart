// ignore_for_file: use_build_context_synchronously, avoid_print, unused_local_variable

import 'imports.dart';

class ExcelGenerator {
  Future<void> requestPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int? version = int.tryParse(androidInfo.version.release);
      if (version != null && version <= 12) {
        PermissionStatus status1 = await Permission.storage.request();
        if (status1 == PermissionStatus.granted) {
          generateCSV(context);
        } else {
          CustomSnackBar.showSnackBar(context, 'Storage permission denied.');
        }
      } else {
        PermissionStatus status2 =
            await Permission.manageExternalStorage.request();
        if (status2 == PermissionStatus.granted) {
          generateCSV(context);
        } else {
          CustomSnackBar.showSnackBar(context, 'Storage permission denied.');
        }
      }
    } else if (Platform.isIOS) {
      PermissionStatus status = await Permission.storage.request();
      if (status == PermissionStatus.granted ||
          status == PermissionStatus.limited) {
        generateCSV(context);
      } else {
        CustomSnackBar.showSnackBar(context, 'Storage permission denied.');
      }
    } else {
      CustomSnackBar.showSnackBar(context, 'Sorry, OS not supported.');
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
              "Saving the Excel (CSV) file ...",
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
      'Year',
      'Department',
      'Section',
      'College',
      'Depart Date',
      'Depart Time',
      'Arrival Date',
      'Arrival Time',
      'Email',
      'Hostel',
      'Student Mobile',
      'Parent Mobile',
    ]);

    // Add data rows
    for (QueryDocumentSnapshot doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      rows.add([
        data['name'] ?? '',
        data['year'].toString(),
        data['department'] ?? '',
        data['section'] ?? '',
        data['college'] ?? '',
        data['depart_date'] ?? '',
        data['depart_time'] ?? '',
        data['arrival_date'] ?? '',
        data['arrival_time'] ?? '',
        data['email'] ?? '',
        data['hostel'] ?? '',
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
      QuerySnapshot querySnapshot = await firestore
          .collection('dashboard')
          .where(FieldPath.documentId, isNotEqualTo: 'sample-document')
          .where('arrival_status', isEqualTo: 1)
          .get();

      String csvData = _generateCSVData(querySnapshot.docs);

      print("Getting the file path location to save the file ...");
      String dir =
          "${(await getExternalStorageDirectory())!.path}/Outpass_Data_${_getCurrentDateAndTime()}.csv";

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
      showErrorDialog(context,
          'Sorry, an error occured while fetching data from database.');
    }
  }

  String _getCurrentDateAndTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy_HH:mm').format(now);
    return formattedDate;
  }
}
