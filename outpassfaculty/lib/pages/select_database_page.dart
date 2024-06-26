import '../utils/imports.dart';

class SelectDatabasePage extends StatefulWidget {
  const SelectDatabasePage({super.key});

  @override
  State<SelectDatabasePage> createState() => _SelectDatabasePageState();
}

class _SelectDatabasePageState extends State<SelectDatabasePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Select Database",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GridButton(context, 'Students'),
                  const SizedBox(width: 10),
                  GridButton(context, 'Faculty')
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GridButton(context, 'Warden'),
                  const SizedBox(width: 10),
                  GridButton(context, 'Security'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
