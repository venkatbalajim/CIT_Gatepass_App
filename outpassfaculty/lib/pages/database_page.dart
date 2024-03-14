// ignore_for_file: avoid_print, use_build_context_synchronously

import '../utils/imports.dart';

String addNewDataMessage = '''
INSTRUCTIONS MUST BE FOLLOWED:

a. The CSV file must have only one sheet. 
b. Must click the UPLOAD button to finish. 
c. The required students data are below:
    1. Name of the student
    2. College email - For student login 
    3. Register No - All letters are capital 
    4. Department - All letters are capital 
    5. Section - All letters are capital 
    6. Year of study - Format: 1, 2, 3, 4 
    7. Student Mobile Number 
    8. Parent Mobile Number 
    9. Hostel Name - First letter in capital 
    10. Room Number 
d. The file MUST have data in this order. 
''';

String deleteAllDataMessage = '''
BEFORE PROCEEDING THE ACTION:

1. This action deletes all the students data currently present in the database.
2. Make sure you have a new CSV file to upload students data in the database. 
''';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  String operation = "None";
  String? selectedFile;
  bool isStoragePermissionGranted = false;
  String filePath = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Future<String?> pickFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        final file = File(result.files.first.path!);
        final directory = await getExternalStorageDirectory();
        final newDirectory = Directory("${directory!.path}/uploads");

        bool presence = await newDirectory.exists();
        if (!presence) {
          await newDirectory.create();
        }

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        final newPath = "${newDirectory.path}/$fileName.csv";
        await file.copy(newPath).then((value) => print("File saved successfully in $newPath"));

        setState(() {
          filePath = newPath;
        });

        return result.files.first.name;
      } else {
        return null;
      }
    }

    Future<bool?> showConfirmationDialog(BuildContext context, String message) async {
      return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            title: const Text('Confirmation'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); 
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); 
                },
                child: const Text('No'),
              ),
            ],
          );
        },
      );
    }

    Widget addNewDataWidgets(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InstructionCard(instruction: addNewDataMessage),
          const SizedBox(height: 20),
          TextButton(
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              fixedSize: MaterialStateProperty.all(const Size(200, 50)),
              backgroundColor: MaterialStateProperty.all(Colors.green[600]),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
            ),
            onPressed: () async {
              bool permissionGranted = await requestStoragePermission();
              if (permissionGranted) {
                String? file = await pickFile();
                if (file != null) {
                  setState(() {
                    selectedFile = file;
                  });
                }
              } else {
                CustomSnackBar.showExitSnackBar(context, "Storage Permission Denied");
              }
            }, 
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_file,
                ),
                SizedBox(width: 10),
                Text(
                  'Upload CSV File', 
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  )
                )
              ],
            ),
          ),
          if (selectedFile != null) ...[
            const SizedBox(height: 20),
            Text(
              'Selected File: $selectedFile',
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                backgroundColor: MaterialStateProperty.all(Colors.red),
                fixedSize: MaterialStateProperty.all(const Size(100, 30)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
              ),
              onPressed: () async {
                bool? confirm = await showConfirmationDialog(context, "Are you sure to upload the data in database?");
                if (confirm != null && confirm) {
                  UploadStudentData uploadStudentData = UploadStudentData(filePath);
                  uploadStudentData.uploadData(context);
                }
              }, 
              child: const Text(
                'UPLOAD',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              )
            )
          ],
        ],
      );
    }

    Widget deleteExistDataWidgets(BuildContext context){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InstructionCard(instruction: deleteAllDataMessage),
          const SizedBox(height: 20),
          TextButton(
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              backgroundColor: MaterialStateProperty.all(Colors.red),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
            ),
            onPressed: () async {
              bool? confirm = await showConfirmationDialog(context, "Are you sure to DELETE all the students data in database?");
              if (confirm != null && confirm) {
                await deleteAllDocuments(context);
              }
            }, 
            child: const Text(
              'DELETE ALL DATA',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            )
          )
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Database Page', style: TextStyle(fontSize: 20)),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(30),
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue[900]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Select Action',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                    customRadioListTile(
                      title: 'None',
                      value: 'None',
                    ),
                    customRadioListTile(
                      title: 'Add new data',
                      value: 'Add new data',
                    ),
                    customRadioListTile(
                      title: 'Delete all data',
                      value: 'Delete all data',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            (operation == "Add new data") ? addNewDataWidgets(context)
              : (operation == "Delete all data") ? deleteExistDataWidgets(context)
                : Center(child: Text(
                    'Currently no action is selected.', 
                    textAlign: TextAlign.center, 
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                      fontSize: 17
                    ),
                  )
                )
          ],
        ),
      ),
    );
  }

  Widget customRadioListTile({required String title, required String value}) {
    return SizedBox(
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: operation,
            activeColor: Colors.blue[900],
            onChanged: (String? selectedValue) {
              setState(() {
                operation = selectedValue!;
                print(operation);
              });
            },
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> requestStoragePermission() async {
  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    int? version = int.tryParse(androidInfo.version.release);
    if (version != null && version <= 12) {
      PermissionStatus status1 = await Permission.storage.request();
      return status1 == PermissionStatus.granted;
    } else {
      PermissionStatus status2 = await Permission.manageExternalStorage.request();
      return status2 == PermissionStatus.granted;
    }
  } else if (Platform.isIOS) {
    PermissionStatus status = await Permission.storage.request();
    return (status == PermissionStatus.granted || status == PermissionStatus.limited);
  } else {
    return false;
  }
}
