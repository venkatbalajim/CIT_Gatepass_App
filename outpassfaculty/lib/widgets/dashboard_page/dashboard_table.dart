import '../../utils/imports.dart';

class DashboardTable extends StatefulWidget {
  final List<DocumentSnapshot>? documents;
  const DashboardTable({super.key, this.documents});

  @override
  State<DashboardTable> createState() => _DashboardTableState();
}

class _DashboardTableState extends State<DashboardTable> {

  void showStudentDialog(
    BuildContext context, 
    String name, String registerNo, String year,
    String department, String section, String hostel, String roomNo,
    String studentMobile, String parentMobile
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 400,
                  child: ListView(
                    children: [
                      InfoCard(label: 'Name', detail: name),
                      InfoCard(label: 'Register No.', detail: registerNo),
                      InfoCard(label: 'Parent Mobile', detail: parentMobile),
                      InfoCard(label: 'Student Mobile', detail: studentMobile),
                      InfoCard(label: 'Year', detail: year),
                      InfoCard(label: 'Department', detail: department),
                      InfoCard(label: 'Section', detail: section),
                      InfoCard(label: 'Hostel', detail: hostel),
                      InfoCard(label: 'Room No.', detail: roomNo),
                    ],
                  )
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  width: 60,
                  child: SmallButton(
                    name: 'Ok', 
                    onTap: () {
                      Navigator.pop(context);
                    }
                  ),
                )
              ],
            ),
          )
        );
      },
    );
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(13, 71, 161, 1),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width - 20.0,
      height: 500,
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
              )
            ),
            columnSpacing: 30.0,
            dividerThickness: 2, 
            columns: [
              DataColumn(label: Container(alignment: Alignment.center, child: const Text('Name'))),
              DataColumn(label: Container(alignment: Alignment.center, child: const Text('Purpose'))),
              DataColumn(label: Container(alignment: Alignment.center, child: const Text('Out Date'))),
              DataColumn(label: Container(alignment: Alignment.center, child: const Text('Out Time'))),
              DataColumn(label: Container(alignment: Alignment.center, child: const Text('In Date'))),
              DataColumn(label: Container(alignment: Alignment.center, child: const Text('In Time'))),
              DataColumn(label: Container(alignment: Alignment.center, child: const Text('More Details'))),
            ],
            rows: (widget.documents?.map((document) {
              final data = document.data() as Map<String, dynamic>?;
              return DataRow(
                cells: [
                  DataCell(
                    Center(child: Text(data!['name'])),
                  ),
                  DataCell(
                    Center(child: Text(data['purpose'])),
                  ),
                  DataCell(
                    Center(child: Text(data['depart_date'] ?? '      ')),
                  ),
                  DataCell(
                    Center(child: Text(data['depart_time'] ?? '       ')),
                  ),
                  DataCell(
                    Center(child: Text(data['arrival_date'] ?? '      ')),
                  ),
                  DataCell(
                    Center(child: Text(data['arrival_time'] ?? '      ')),
                  ),
                  DataCell(
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              String name = data['name'];
                              String registerNo = data['register_no'];
                              String year = currentYear(data['year']);
                              String department = data['department'];
                              String section = data['section'];
                              String hostel = data['hostel'];
                              String roomNo = data['room_no'];
                              String studentMobile = data['student_mobile'].toString();
                              String parentMobile = data['parent_mobile'].toString();
                              showStudentDialog(context, name, registerNo, year, department, section, hostel, roomNo, studentMobile, parentMobile);
                            }, 
                            icon: Icon(
                              Icons.person, 
                              size: 30,
                              color: Colors.blue[900],
                            )
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              );}).toList() ?? []), 
          ),
        ),
      ),
    );
  }
}
