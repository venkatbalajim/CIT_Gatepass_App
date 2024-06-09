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
                child: Text(
                  "Outpass Security App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 28,
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/scanner');
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color.fromRGBO(13, 71, 161, 1),
                          width: 2.5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        color: Colors.blue[900],
                        size: 60,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Scan QR Code',
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
