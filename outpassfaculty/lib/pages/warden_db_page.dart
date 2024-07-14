// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import '../utils/imports.dart';

class WardenDBPage extends StatefulWidget {
  const WardenDBPage({super.key});

  @override
  State<WardenDBPage> createState() => _WardenDBPageState();
}

class _WardenDBPageState extends State<WardenDBPage> {
  WardenDatabase database = WardenDatabase();
  String operation = "None";
  Map<dynamic, dynamic>? document;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController hostelController = TextEditingController();
  String adminController = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: database.getWardenData(),
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
                  "Warden Database",
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
                            title: 'Add a warden data',
                            value: 'Add a warden data',
                            groupValue: operation,
                          ),
                          customRadioTile(
                            title: 'Update a warden data',
                            value: 'Update a warden data',
                            groupValue: operation,
                          ),
                          customRadioTile(
                            title: 'Delete a warden data',
                            value: 'Delete a warden data',
                            groupValue: operation,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  (operation == "Delete a warden data")
                      ? deleteWardenDataWidget(context, snapshot.data)
                      : (operation == "Update a warden data")
                          ? updateWardenDataWidget(context, snapshot.data)
                          : (operation == "Add a warden data")
                              ? addWardenDataWidget(context)
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
                  hostelController.clear();
                  adminController = "";
                  operation = selectedValue!;
                });
              } else {
                setState(() {
                  adminController = selectedValue!;
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

  Widget addWardenDataWidget(BuildContext context) {
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
          hintText: 'Warden Name',
        ),
        const SizedBox(height: 10),
        InputField(
          controller: hostelController,
          hintText: 'Hostel Name',
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue[900]!, width: 2),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Is the new warden an ADMIN?',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              customRadioTile(
                title: 'Yes',
                value: 'yes',
                groupValue: adminController,
              ),
              customRadioTile(
                title: 'No',
                value: 'no',
                groupValue: adminController,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () async {
            if (nameController.text.isEmpty ||
                emailController.text.isEmpty ||
                hostelController.text.isEmpty ||
                adminController.isEmpty) {
              CustomSnackBar.showSnackBar(context, "Please fill all details.");
              return;
            }
            bool? status = await showConfirmationDialog(context,
                "Are you sure to add the warden data. Kindly check the details before adding in the database.");
            if (status != null && status) {
              List<dynamic> data = List.empty(growable: true);
              data.add(nameController.text);
              data.add(emailController.text);
              data.add(hostelController.text);
              data.add(adminController);

              Map<String, dynamic> newData = database.wardenMap(data);
              await database.addWardenData(context, newData);

              setState(() {
                document = null;
                emailController.clear();
                nameController.clear();
                hostelController.clear();
                adminController = "";
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

  Widget updateWardenDataWidget(BuildContext context,
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
                  adminController = document!['admin'];
                });
              } else {
                setState(() {
                  document = null;
                  emailController.clear();
                  nameController.clear();
                  hostelController.clear();
                  adminController = "";
                });
                CustomSnackBar.showSnackBar(
                  context,
                  "Warden email is not in the database.",
                );
              }
            } else {
              CustomSnackBar.showSnackBar(
                context,
                "Please enter the warden email.",
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
            hintText: 'Warden Name',
            preValue: document!['name'],
          ),
          const SizedBox(height: 10),
          InputField(
            controller: hostelController,
            hintText: 'Hostel Name',
            preValue: document!['hostel'],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[900]!, width: 2),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Is the warden an ADMIN?',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                customRadioTile(
                  title: 'Yes',
                  value: 'yes',
                  groupValue: adminController,
                ),
                customRadioTile(
                  title: 'No',
                  value: 'no',
                  groupValue: adminController,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              if (nameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  hostelController.text.isEmpty ||
                  adminController.isEmpty) {
                CustomSnackBar.showSnackBar(
                    context, "Please fill all details.");
                return;
              }
              bool? status = await showConfirmationDialog(context,
                  "Are you sure to update the warden data. Kindly check the details before updating.");
              if (status != null && status) {
                List<dynamic> data = List.empty(growable: true);
                data.add(nameController.text);
                data.add(emailController.text);
                data.add(hostelController.text);
                data.add(adminController);

                Map<String, dynamic> newData = database.wardenMap(data);
                await database.updateWardenData(context, newData);

                setState(() {
                  document = null;
                  emailController.clear();
                  nameController.clear();
                  hostelController.clear();
                  adminController = "";
                });
              }
            },
            child: SingleActionButton(
              color: Colors.green[700]!,
              buttonName: "UPDATE",
            ),
          )
        ]
      ],
    );
  }

  Widget deleteWardenDataWidget(BuildContext context,
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
                    'Are you sure to delete the warden data? This cannot be undone');
                if (status != null && status) {
                  await database.deleteWardenData(
                      context, emailController.text);
                }
              } else {
                CustomSnackBar.showSnackBar(
                  context,
                  "Warden email is not in the database.",
                );
              }
            } else {
              CustomSnackBar.showSnackBar(
                context,
                "Please enter the warden email.",
              );
            }
            setState(() {
              document = null;
              emailController.clear();
              nameController.clear();
              hostelController.clear();
              adminController = "";
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
