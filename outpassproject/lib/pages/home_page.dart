import '../utils/imports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserDetails userDetail = UserDetails();
  bool _backButtonPressedOnce = false;
  DateTime? _lastBackPressed;
  int _selectedIndex = 1;
  final PageController controller =
      PageController(initialPage: 1, keepPage: true);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    controller.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<Widget> _getOutpassPage() async {
    return await userDetail.isSubmitted(context);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_backButtonPressedOnce) {
          return true;
        } else {
          CustomSnackBar.showExitSnackBar(context);
          _backButtonPressedOnce = true;

          if (_lastBackPressed == null ||
              DateTime.now().difference(_lastBackPressed!) >
                  const Duration(seconds: 2)) {
            _lastBackPressed = DateTime.now();
            await Future.delayed(const Duration(seconds: 2));
          } else {
            SystemNavigator.pop();
            return true;
          }
          _backButtonPressedOnce = false;
          return false;
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: PageView(
              controller: controller,
              onPageChanged: (value) {
                setState(() {
                  _selectedIndex = value;
                });
              },
              children: [
                const ProfilePage(),
                FutureBuilder<Widget>(
                  future: _getOutpassPage(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: Colors.blue[900]));
                    } else if (snapshot.hasError) {
                      return Center(
                          child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Text(
                          textAlign: TextAlign.center,
                          'Sorry, unable to load the page.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900]),
                        ),
                      ));
                    } else {
                      return snapshot.data ??
                          const Center(
                              child: Text('Sorry, unable to load the page.'));
                    }
                  },
                ),
                const SettingsPage()
              ],
            ),
          ),
          bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
            child: BottomNavigationBar(
              iconSize: 24,
              currentIndex: _selectedIndex,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              selectedItemColor: Colors.blue[900],
              unselectedItemColor: Colors.blue[900],
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outlined),
                  activeIcon: Icon(Icons.person),
                  label: "Profile",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment_outlined),
                  activeIcon: Icon(Icons.assignment),
                  label: "Outpass",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: "Settings",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
