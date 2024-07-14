// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import '../utils/imports.dart';

class FacultyDBPage extends StatefulWidget {
  const FacultyDBPage({super.key});

  @override
  State<FacultyDBPage> createState() => _FacultyDBPageState();
}

class _FacultyDBPageState extends State<FacultyDBPage> {
  FacultyDatabase database = FacultyDatabase();
  String operation = "None";
  Map<dynamic, dynamic>? document;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController collegeController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  String positionController = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: database.getFacultyData(),
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
                  "Faculty Database",
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
                          customRadioTile(
                            title: 'None',
                            value: 'None',
                            groupValue: operation,
                          ),
                          customRadioTile(
                            title: 'Add a faculty data',
                            value: 'Add a faculty data',
                            groupValue: operation,
                          ),
                          customRadioTile(
                            title: 'Update a faculty data',
                            value: 'Update a faculty data',
                            groupValue: operation,
                          ),
                          customRadioTile(
                            title: 'Delete a faculty data',
                            value: 'Delete a faculty data',
                            groupValue: operation,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  (operation == "Delete a faculty data")
                      ? deleteFacultyDataWidget(context, snapshot.data)
                      : (operation == "Update a faculty data")
                          ? updateFacultyDataWidget(context, snapshot.data)
                          : (operation == "Add a faculty data")
                              ? addFacultyDataWidget(context)
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

  Widget customRadioTile(
      {required String title,
      required String value,
      required String groupValue}) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: groupValue,
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: (String? selectedValue) {
              if (groupValue == operation) {
                setState(() {
                  document = null;
                  emailController.clear();
                  nameController.clear();
                  collegeController.clear();
                  departmentController.clear();
                  sectionController.clear();
                  yearController.clear();
                  positionController = "";
                  operation = selectedValue!;
                });
              } else {
                setState(() {
                  positionController = selectedValue!;
                });
              }
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

  Widget deleteFacultyDataWidget(BuildContext context,
      List<QueryDocumentSnapshot<Map<dynamic, dynamic>>>? documents) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InputField(controller: emailController, hintText: 'Email ID'),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () async {
            if (emailController.text.isNotEmpty) {
              Iterable<QueryDocumentSnapshot<Map>>? selected = documents?.where(
                  (element) => element['email'] == emailController.text);
              if (selected != null && selected.isNotEmpty) {
                bool? status = await showConfirmationDialog(context,
                    'Are you sure to delete the faculty data? This cannot be undone');
                if (status != null && status) {
                  await database.deleteFacultyData(
                      context, emailController.text);
                }
              } else {
                CustomSnackBar.showSnackBar(
                  context,
                  "Faculty email is not in the database.",
                );
              }
            } else {
              CustomSnackBar.showSnackBar(
                context,
                "Please enter the faculty email.",
              );
            }
            setState(() {
              document = null;
              emailController.clear();
              nameController.clear();
              collegeController.clear();
              departmentController.clear();
              sectionController.clear();
              yearController.clear();
              positionController = "";
            });
          },
          child: SingleActionButton(
            color: Colors.blue[900]!,
            buttonName: "Search",
          ),
        )
      ],
    );
  }

  Widget updateFacultyDataWidget(BuildContext context,
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
                  positionController = document!['position'];
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
                  positionController = "";
                });
                CustomSnackBar.showSnackBar(
                  context,
                  "Faculty email is not in the database.",
                );
              }
            } else {
              CustomSnackBar.showSnackBar(
                context,
                "Please enter the faculty email.",
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
          customRadioTile(
              title: 'Class Advisor',
              value: 'Class Advisor',
              groupValue: positionController),
          customRadioTile(
              title: 'HoD', value: 'HoD', groupValue: positionController),
          const SizedBox(height: 15),
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
              if (positionController == "Class Advisor")
                Expanded(
                  child: InputField(
                    controller: sectionController,
                    hintText: 'Section',
                    preValue: document!['section'],
                  ),
                ),
              if (positionController == "Class Advisor")
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
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              if (nameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  collegeController.text.isEmpty ||
                  departmentController.text.isEmpty ||
                  yearController.text.isEmpty ||
                  positionController.isEmpty ||
                  (positionController == "Class Advisor" &&
                      sectionController.text.isEmpty)) {
                CustomSnackBar.showSnackBar(
                    context, "Please fill all details.");
                return;
              }
              bool? status = await showConfirmationDialog(context,
                  "Are you sure to update the faculty data. Kindly check the details before updating.");
              if (status != null && status) {
                List<dynamic> data = List.empty(growable: true);
                data.add(positionController);
                data.add(nameController.text);
                data.add(emailController.text);
                data.add(collegeController.text);
                data.add(departmentController.text);
                data.add(int.parse(yearController.text));
                if (positionController == "Class Advisor") {
                  data.add(sectionController.text);
                }

                Map<String, dynamic> newData = database.facultyMap(data);
                await database.updateFacultyData(context, newData);

                setState(() {
                  document = null;
                  emailController.clear();
                  nameController.clear();
                  collegeController.clear();
                  departmentController.clear();
                  sectionController.clear();
                  yearController.clear();
                  positionController = "";
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

  Widget addFacultyDataWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customRadioTile(
          title: 'Class Advisor',
          value: 'Class Advisor',
          groupValue: positionController,
        ),
        customRadioTile(
          title: 'HoD',
          value: 'HoD',
          groupValue: positionController,
        ),
        const SizedBox(height: 15),
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
            if (positionController == "Class Advisor")
              Expanded(
                child: InputField(
                  controller: sectionController,
                  hintText: 'Section',
                ),
              ),
            if (positionController == "Class Advisor")
              const SizedBox(width: 10),
            Expanded(
              child: InputField(
                controller: yearController,
                hintText: 'Year',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () async {
            if (nameController.text.isEmpty ||
                emailController.text.isEmpty ||
                collegeController.text.isEmpty ||
                departmentController.text.isEmpty ||
                yearController.text.isEmpty ||
                positionController.isEmpty ||
                (positionController == "Class Advisor" &&
                    sectionController.text.isEmpty)) {
              CustomSnackBar.showSnackBar(context, "Please fill all details.");
              return;
            }
            bool? status = await showConfirmationDialog(context,
                "Are you sure to add the faculty data. Kindly check the details before adding in the database.");
            if (status != null && status) {
              List<dynamic> data = List.empty(growable: true);
              data.add(positionController);
              data.add(nameController.text);
              data.add(emailController.text);
              data.add(collegeController.text);
              data.add(departmentController.text);
              data.add(int.parse(yearController.text));
              if (positionController == "Class Advisor") {
                data.add(sectionController.text);
              }

              Map<String, dynamic> newData = database.facultyMap(data);
              await database.addFacultyData(context, newData);

              setState(() {
                document = null;
                emailController.clear();
                nameController.clear();
                collegeController.clear();
                departmentController.clear();
                sectionController.clear();
                yearController.clear();
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
