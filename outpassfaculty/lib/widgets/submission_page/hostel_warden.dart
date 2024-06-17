// ignore_for_file: avoid_print

import '../../utils/imports.dart';

class WardenSubmissionContainer extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<dynamic, dynamic>>>? outpassList;

  const WardenSubmissionContainer({super.key, required this.outpassList});

  @override
  State<WardenSubmissionContainer> createState() =>
      _WardenSubmissionContainerState();
}

class _WardenSubmissionContainerState extends State<WardenSubmissionContainer> {
  void showStudentDialog(
      BuildContext context,
      String name,
      String year,
      String department,
      String section,
      String hostel,
      String studentMobile,
      String parentMobile) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Student Details',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          content: Container(
            padding: const EdgeInsets.all(10),
            width: 200,
            height: 450,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoCard(label: 'Name', detail: name),
                  InfoCard(label: 'Student Mobile', detail: studentMobile),
                  InfoCard(label: 'Parent Mobile', detail: parentMobile),
                  InfoCard(label: 'Year', detail: year),
                  InfoCard(label: 'Department', detail: department),
                  InfoCard(label: 'Section', detail: section),
                  InfoCard(label: 'Hostel', detail: hostel),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Ok',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            )
          ],
        );
      },
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

  String currentStatus(int status) {
    if (status == 1) {
      return "Approved";
    } else if (status == -1) {
      return "Declined";
    } else if (status == 10) {
      return "No Need";
    } else {
      return "Pending";
    }
  }

  String currentYear(int year) {
    if (year == 1) {
      return "1";
    } else if (year == 2) {
      return "2";
    } else if (year == 3) {
      return "3";
    } else {
      return "4";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                bool? confirm = await showConfirmationDialog(
                  context,
                  "Are you sure to approve all outpass at once? This cannot be undone.",
                );
                if (confirm != null && confirm) {
                  while (widget.outpassList != null &&
                      widget.outpassList!.isNotEmpty) {
                    QueryDocumentSnapshot<Map<dynamic, dynamic>> document =
                        widget.outpassList!.first;
                    await updateWardenStatus(document.id, 1);
                    widget.outpassList?.removeAt(0);
                  }
                  setState(() {});
                }
              },
              child: SingleActionButton(
                buttonName: 'Approve All',
                color: Colors.green[700] ?? Colors.green,
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () async {
                bool? confirm = await showConfirmationDialog(
                  context,
                  "Are you sure to decline all outpass at once? This cannot be undone.",
                );
                if (confirm != null && confirm) {
                  while (widget.outpassList != null &&
                      widget.outpassList!.isNotEmpty) {
                    QueryDocumentSnapshot<Map<dynamic, dynamic>> document =
                        widget.outpassList!.first;
                    await updateWardenStatus(document.id, -1);
                    widget.outpassList?.removeAt(0);
                  }
                  setState(() {});
                }
              },
              child: const SingleActionButton(
                buttonName: 'Decline All',
                color: Colors.red,
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromRGBO(13, 71, 161, 1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width - 20.0,
          height: MediaQuery.of(context).size.height - 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: const TableBorder(
                    verticalInside: BorderSide(
                  width: 2,
                  style: BorderStyle.solid,
                  color: Color.fromRGBO(13, 71, 161, 1),
                )),
                columnSpacing: 30.0,
                dividerThickness: 2,
                columns: [
                  DataColumn(
                      label: Container(
                          alignment: Alignment.center,
                          child: const Text('Name'))),
                  DataColumn(
                      label: Container(
                          alignment: Alignment.center,
                          child: const Text('Out Date'))),
                  DataColumn(
                      label: Container(
                          alignment: Alignment.center,
                          child: const Text('Out Time'))),
                  DataColumn(
                      label: Container(
                          alignment: Alignment.center,
                          child: const Text('In Date'))),
                  DataColumn(
                      label: Container(
                          alignment: Alignment.center,
                          child: const Text('In Time'))),
                  DataColumn(
                      label: Container(
                          alignment: Alignment.center,
                          child: const Text('Purpose'))),
                  DataColumn(
                      label: Container(
                          alignment: Alignment.center,
                          child: const Text('Advisor Status'))),
                  DataColumn(
                      label: Container(
                          alignment: Alignment.center,
                          child: const Text('HoD Status'))),
                  DataColumn(
                      label: Container(
                          alignment: Alignment.center,
                          child: const Text('Actions'))),
                ],
                rows: widget.outpassList?.map((document) {
                      final data = document.data();
                      return DataRow(
                        cells: [
                          DataCell(
                            Center(child: Text(data['name'])),
                          ),
                          DataCell(
                            Center(child: Text(data['out_date'])),
                          ),
                          DataCell(
                            Center(child: Text(data['out_time'])),
                          ),
                          DataCell(
                            Center(child: Text(data['in_date'])),
                          ),
                          DataCell(
                            Center(child: Text(data['in_time'])),
                          ),
                          DataCell(
                            Center(child: Text(data['purpose'])),
                          ),
                          DataCell(
                            Center(
                                child: Text(
                                    currentStatus(data['advisor_status']))),
                          ),
                          DataCell(
                            Center(
                                child: Text(currentStatus(data['hod_status']))),
                          ),
                          DataCell(
                            Center(
                                child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      String name = data['name'];
                                      String year = currentYear(data['year']);
                                      String department = data['department'];
                                      String section = data['section'];
                                      String hostel = data['hostel'];
                                      String studentMobile =
                                          data['student_mobile'].toString();
                                      String parentMobile =
                                          data['parent_mobile'].toString();
                                      showStudentDialog(
                                          context,
                                          name,
                                          year,
                                          department,
                                          section,
                                          hostel,
                                          studentMobile,
                                          parentMobile);
                                    },
                                    icon: Icon(
                                      Icons.person,
                                      size: 30,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      bool? confirm =
                                          await showConfirmationDialog(context,
                                              "Are you sure to approve?");
                                      if (confirm != null && confirm) {
                                        await updateWardenStatus(
                                            document.id, 1);
                                        setState(() {
                                          widget.outpassList?.remove(document);
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.check_circle,
                                      size: 30,
                                      color: Colors.green,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      bool? confirm =
                                          await showConfirmationDialog(context,
                                              "Are you sure to decline?");
                                      if (confirm != null && confirm) {
                                        await updateWardenStatus(
                                            document.id, -1);
                                        setState(() {
                                          widget.outpassList?.remove(document);
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      size: 30,
                                      color: Colors.red,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      bool? confirm = await showConfirmationDialog(
                                          context,
                                          "Are you sure to make Advisor and HoD status as NO NEED?\nThis cannot be undone.");
                                      if (confirm != null && confirm) {
                                        await noNeedUpdateStatus(
                                            document.id, 10);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.visibility_off_outlined,
                                      size: 30,
                                      color: Colors.orange[500],
                                    )),
                              ],
                            )),
                          ),
                        ],
                      );
                    }).toList() ??
                    [],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
