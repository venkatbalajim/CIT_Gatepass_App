import '../../utils/imports.dart';

class HostelCounterCard extends StatelessWidget {
  final String hostelName;
  final String departCount;
  final String arrivalCount;

  const HostelCounterCard({
    super.key,
    required this.hostelName,
    required this.departCount,
    required this.arrivalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromRGBO(13, 71, 161, 1),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hostelName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10), 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Depart Count: $departCount',
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                'Arrival Count: $arrivalCount',
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DepartmentCounterCard extends StatelessWidget {
  final String deptName;
  final String departCount;
  final String arrivalCount;
  final List<DocumentSnapshot<Map<String, dynamic>>>? documents;

  const DepartmentCounterCard({
    super.key,
    required this.deptName,
    required this.departCount,
    required this.arrivalCount,
    this.documents,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DepartmentDialog(
              deptName: deptName,
              documents: documents,
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromRGBO(13, 71, 161, 1),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deptName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Depart Count: $departCount',
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  'Arrival Count: $arrivalCount',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DepartmentDialog extends StatelessWidget {
  final String deptName;
  final List<DocumentSnapshot<Map<String, dynamic>>>? documents;

  const DepartmentDialog({
    super.key,
    required this.deptName,
    this.documents,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 600,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                deptName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: documents != null
                    ? _provideDeptData(deptName) 
                    : const Center(child: Text('No data available.')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _provideDeptData(String deptName) {
    List<String> sections = ['A', 'B', 'C', 'D'];

    if (documents != null && documents!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int year = 1; year <= 4; year++)
            ..._buildYearSections(deptName, year, sections), 
        ],
      );
    } else {
      return const SizedBox(child: Text("No data available."));
    }
  }

  List<Widget> _buildYearSections(
      String deptName, int year, List<String> sections) {
    List<Widget> yearSections = [];

    for (String section in sections) {
      bool hasDocuments = documents!.any(
        (doc) =>
            doc['year'] == year &&
            doc['section'] == section &&
            doc['department'] == deptName, 
      );

      if (hasDocuments) {
        List<DocumentSnapshot<Map<String, dynamic>>> yearSectionDocuments =
            documents!.where(
          (doc) =>
              doc['year'] == year &&
              doc['section'] == section &&
              doc['department'] == deptName, 
        ).toList();

        int departCount = yearSectionDocuments
            .where((doc) => doc['depart_status'] == 1)
            .length;

        int arrivalCount = yearSectionDocuments
            .where((doc) => doc['arrival_status'] == 1)
            .length;

        yearSections.addAll([
          const SizedBox(height: 10),
          Text(
            'Year : $year',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Section : $section',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Depart Count : $departCount\nArrival Count : $arrivalCount',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 10),
        ]);
      }
    }
    return yearSections;
  }
}
