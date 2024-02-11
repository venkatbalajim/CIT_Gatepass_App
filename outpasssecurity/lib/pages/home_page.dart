import '../../utils/imports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamed(context, '/');
          return false; 
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: Text("Outpass Security Application", 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 100,),
                SmallButton(
                  name: "Scan QR Code",
                  onTap: () {
                    Navigator.pushNamed(context, '/scanner');
                  },
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
