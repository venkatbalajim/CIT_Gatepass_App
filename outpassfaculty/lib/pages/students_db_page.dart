// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import '../utils/imports.dart';

String addNewDataMessage = '''
INSTRUCTIONS MUST BE FOLLOWED:

a. The CSV file must have only one sheet. 
b. Must click the UPLOAD button to finish. 
c. The first row must be the header row. 
d. The required students data are in order:
    1. Name of the student
    2. College email - For student login 
    3. College - CIT or CITAR
    4. Department - All must in capital letters
    5. Section - All must in capital letters 
    6. Year of study - Format: 1, 2, 3, 4 
    7. Student Mobile Number 
    8. Parent Mobile Number 
    9. Hostel Name 
e. The file MUST have data in this order. 
''';

String deleteAllStudentsDataMessage = '''
BEFORE PROCEEDING THE ACTION:

1. This action deletes all the students data currently present in the database.
2. Make sure you have a new CSV file to upload students data in the database. 
''';

class StudentsDBPage extends StatefulWidget {
  const StudentsDBPage({super.key});

  @override
  State<StudentsDBPage> createState() => _StudentsDBPageState();
}

class _StudentsDBPageState extends State<StudentsDBPage> {
  StudentsDatabase database = StudentsDatabase();
  AddStudentsData addData = AddStudentsData('');
  String operation = "None";
  String? selectedFile;
  bool isStoragePermissionGranted = false;
  String filePath = '';
  Map<dynamic, dynamic>? document;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController collegeController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController studentMobileController = TextEditingController();
  TextEditingController parentMobileController = TextEditingController();
  TextEditingController hostelController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

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
      await file
          .copy(newPath)
          .then((value) => print("File saved successfully in $newPath"));

      setState(() {
        filePath = newPath;
        document = null;
        emailController.clear();
        nameController.clear();
        collegeController.clear();
        departmentController.clear();
        sectionController.clear();
        yearController.clear();
        studentMobileController.clear();
        parentMobileController.clear();
        hostelController.clear();
      });

      return result.files.first.name;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: database.getStudentsData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SafeArea(
            child: Scaffold(
              body: Center(
                child: Dialog(
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
                          "Please wait a moment",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          showErrorDialog(
              context, "Sorry, an error occurred. Please try later.");
          return const SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 60,
                foregroundColor: Theme.of(context).colorScheme.primary,
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: const Text(
                  "Students Database",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          customRadioListTile(
                            title: 'None',
                            value: 'None',
                          ),
                          customRadioListTile(
                            title: 'Add a student data',
                            value: 'Add a student data',
                          ),
                          customRadioListTile(
                            title: 'Add data from CSV file',
                            value: 'Add data from CSV file',
                          ),
                          customRadioListTile(
                            title: 'Delete all students data',
                            value: 'Delete all students data',
                          ),
                          customRadioListTile(
                            title: 'Update a student data',
                            value: 'Update a student data',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  (operation == "Add a student data")
                      ? addStudentData(context)
                      : (operation == "Add data from CSV file")
                          ? addDataFromCSVWidget(context)
                          : (operation == "Delete all students data")
                              ? deleteAllStudentsDataWidget(context)
                              : (operation == "Update a student data")
                                  ? updateStudentDataWidget(
                                      context, snapshot.data)
                                  : Center(
                                      child: Text(
                                        'Currently no action is selected.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17),
                                      ),
                                    ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget customRadioListTile({required String title, required String value}) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: operation,
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: (String? selectedValue) {
              setState(() {
                document = null;
                emailController.clear();
                nameController.clear();
                collegeController.clear();
                departmentController.clear();
                sectionController.clear();
                yearController.clear();
                studentMobileController.clear();
                parentMobileController.clear();
                hostelController.clear();
                operation = selectedValue!;
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

  Widget addDataFromCSVWidget(BuildContext context) {
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
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
          ),
          onPressed: () async {
            bool permissionGranted = await database.requestStoragePermission();
            if (permissionGranted) {
              String? file = await pickFile();
              if (file != null) {
                setState(() {
                  selectedFile = file;
                  document = null;
                  emailController.clear();
                  nameController.clear();
                  collegeController.clear();
                  departmentController.clear();
                  sectionController.clear();
                  yearController.clear();
                  studentMobileController.clear();
                  parentMobileController.clear();
                  hostelController.clear();
                });
              }
            } else {
              CustomSnackBar.showSnackBar(context, "Storage Permission Denied");
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
              Text('Upload CSV File',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ))
            ],
          ),
        ),
        if (selectedFile != null) ...[
          const SizedBox(height: 20),
          Text(
            'Selected File: $selectedFile',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
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
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
              ),
              onPressed: () async {
                bool? confirm = await showConfirmationDialog(
                    context, "Are you sure to upload the data in database?");
                if (confirm != null && confirm) {
                  AddStudentsData uploadStudentData = AddStudentsData(filePath);
                  uploadStudentData.uploadData(context);
                }
              },
              child: const Text(
                'UPLOAD',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ))
        ],
      ],
    );
  }

  Widget deleteAllStudentsDataWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InstructionCard(instruction: deleteAllStudentsDataMessage),
        const SizedBox(height: 20),
        TextButton(
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              backgroundColor: MaterialStateProperty.all(Colors.red),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
            ),
            onPressed: () async {
              bool? confirm = await showConfirmationDialog(context,
                  "Are you sure to DELETE all the students data in database?");
              if (confirm != null && confirm) {
                await deleteAllStudentsData(context);
              }
            },
            child: const Text(
              'DELETE ALL DATA',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ))
      ],
    );
  }

  Widget addStudentData(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InputField(
          controller: emailController,
          hintText: "Email ID",
        ),
        const SizedBox(height: 10),
        InputField(
          controller: nameController,
          hintText: 'Name',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: InputField(
                controller: collegeController,
                hintText: 'College',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InputField(
                controller: departmentController,
                hintText: 'Department',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: InputField(
                controller: sectionController,
                hintText: 'Section',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InputField(
                controller: yearController,
                hintText: 'Year',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        InputField(
          controller: studentMobileController,
          hintText: 'Student Mobile',
        ),
        const SizedBox(height: 10),
        InputField(
          controller: parentMobileController,
          hintText: 'Parent Mobile',
        ),
        const SizedBox(height: 10),
        InputField(
          controller: hostelController,
          hintText: 'Hostel Name',
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () async {
            if (nameController.text.isEmpty ||
                emailController.text.isEmpty ||
                collegeController.text.isEmpty ||
                departmentController.text.isEmpty ||
                sectionController.text.isEmpty ||
                yearController.text.isEmpty ||
                studentMobileController.text.isEmpty ||
                parentMobileController.text.isEmpty ||
                hostelController.text.isEmpty) {
              CustomSnackBar.showSnackBar(context, "Please fill all details.");
              return;
            }
            bool? status = await showConfirmationDialog(context,
                "Are you sure to add the student data. Kindly check the details before adding in the database.");
            if (status != null && status) {
              List<dynamic> data = List.empty(growable: true);
              data.add(nameController.text);
              data.add(emailController.text);
              data.add(collegeController.text);
              data.add(departmentController.text);
              data.add(sectionController.text);
              data.add(int.parse(yearController.text));
              data.add(int.parse(studentMobileController.text));
              data.add(int.parse(parentMobileController.text));
              data.add(hostelController.text);
              Map<String, dynamic> newData =
                  addData.createCustomMap(data, context);
              await addData.addData(context, newData);
              setState(() {
                document = null;
                emailController.clear();
                nameController.clear();
                collegeController.clear();
                departmentController.clear();
                sectionController.clear();
                yearController.clear();
                studentMobileController.clear();
                parentMobileController.clear();
                hostelController.clear();
              });
            }
          },
          child: SingleActionButton(
            color: Colors.green[700]!,
            buttonName: "ADD",
          ),
        )
      ],
    );
  }

  Widget updateStudentDataWidget(BuildContext context,
      List<QueryDocumentSnapshot<Map<dynamic, dynamic>>>? documents) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InputField(
          controller: emailController,
          hintText: "Email ID",
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            if (emailController.text.isNotEmpty) {
              Iterable<QueryDocumentSnapshot<Map>>? selected = documents?.where(
                  (element) => element['email'] == emailController.text);

              if (selected != null && selected.isNotEmpty) {
                setState(() {
                  document = selected.first.data();
                  emailController.text = document!['email'];
                });
              } else {
                setState(() {
                  document = null;
                  emailController.clear();
                  nameController.clear();
                  collegeController.clear();
                  departmentController.clear();
                  sectionController.clear();
                  yearController.clear();
                  studentMobileController.clear();
                  parentMobileController.clear();
                  hostelController.clear();
                });
                CustomSnackBar.showSnackBar(
                  context,
                  "Student email is not in the database.",
                );
              }
            } else {
              CustomSnackBar.showSnackBar(
                context,
                "Please enter the student email.",
              );
            }
          },
          child: SingleActionButton(
            color: Colors.blue[900]!,
            buttonName: "Search",
          ),
        ),
        if (document != null) ...[
          const SizedBox(height: 20),
          InputField(
            controller: nameController,
            hintText: 'Name',
            preValue: document!['name'],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: InputField(
                  controller: collegeController,
                  hintText: 'College',
                  preValue: document!['college'],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InputField(
                  controller: departmentController,
                  hintText: 'Department',
                  preValue: document!['department'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: InputField(
                  controller: sectionController,
                  hintText: 'Section',
                  preValue: document!['section'],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InputField(
                  controller: yearController,
                  hintText: 'Year',
                  preValue: document!['year'].toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InputField(
            controller: studentMobileController,
            hintText: 'Student Mobile',
            preValue: document!['student_mobile'].toString(),
          ),
          const SizedBox(height: 10),
          InputField(
            controller: parentMobileController,
            hintText: 'Parent Mobile',
            preValue: document!['parent_mobile'].toString(),
          ),
          const SizedBox(height: 10),
          InputField(
            controller: hostelController,
            hintText: 'Hostel Name',
            preValue: document!['hostel'],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              if (nameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  collegeController.text.isEmpty ||
                  departmentController.text.isEmpty ||
                  sectionController.text.isEmpty ||
                  yearController.text.isEmpty ||
                  studentMobileController.text.isEmpty ||
                  parentMobileController.text.isEmpty ||
                  hostelController.text.isEmpty) {
                CustomSnackBar.showSnackBar(
                    context, "Please fill all details.");
                return;
              }
              bool? status = await showConfirmationDialog(context,
                  "Are you sure to update the student data. Kindly check the details before updating.");
              if (status != null && status) {
                List<dynamic> data = List.empty(growable: true);
                data.add(nameController.text);
                data.add(emailController.text);
                data.add(collegeController.text);
                data.add(departmentController.text);
                data.add(sectionController.text);
                data.add(int.parse(yearController.text));
                data.add(int.parse(studentMobileController.text));
                data.add(int.parse(parentMobileController.text));
                data.add(hostelController.text);
                Map<String, dynamic> newData =
                    addData.createCustomMap(data, context);
                await addData.updateData(context, newData);
                setState(() {
                  document = null;
                  emailController.clear();
                  nameController.clear();
                  collegeController.clear();
                  departmentController.clear();
                  sectionController.clear();
                  yearController.clear();
                  studentMobileController.clear();
                  parentMobileController.clear();
                  hostelController.clear();
                });
              }
            },
            child: SingleActionButton(
              color: Colors.green[700]!,
              buttonName: "UPDATE",
            ),
          )
        ],
      ],
    );
  }

  Future<bool?> showConfirmationDialog(
      BuildContext context, String message) async {
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
}
