// ignore_for_file: avoid_print, use_build_context_synchronously

import '../utils/imports.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Database Page', style: TextStyle(fontSize: 20)),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
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
                    color: Theme.of(context).colorScheme.primary,
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
                          color: Theme.of(context).colorScheme.primary,
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
            activeColor: Theme.of(context).colorScheme.primary,
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
