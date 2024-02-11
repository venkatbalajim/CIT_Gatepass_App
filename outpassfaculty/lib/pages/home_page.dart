import '../../utils/imports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const button_1 = "User Profile";
  static const button_2 = "Outpass";
  static const button_3 = "Dashboard";
  static const button_4 = "Logout";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hostel Outpass Application",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 200),
              HomeButton(context, button_1),
              const SizedBox(height: 20),
              HomeButton(context, button_2),
              const SizedBox(height: 20),
              HomeButton(context, button_3),
              const SizedBox(height: 20),
              HomeButton(context, button_4),
            ],
          ),
        ),
      ),
    );
  }
}
