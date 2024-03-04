// ignore_for_file: use_build_context_synchronously

import '../../utils/imports.dart';

const button_1 = "User Profile";
const button_2 = "Outpass";
const button_3 = "Dashboard";
const button_4 = "Logout";
const button_5 = "Database";

Widget? getButtonIcon(String name) {
  switch (name) {
    case button_1:
      return const Icon(Icons.person, color: Colors.white, size: 22,);
    case button_2:
      return const Icon(Icons.assignment, color: Colors.white, size: 22,);
    case button_3:
      return const Icon(Icons.dashboard, color: Colors.white, size: 22,);
    case button_4:
      return const Icon(Icons.logout, color: Colors.white, size: 22,);
    case button_5:
      return const Icon(Icons.storage, color: Colors.white, size: 22,);
    default:
      return null;
  }
}

Color? getButtonColor(String name) {
  return Colors.blue[900];
}

// ignore: non_constant_identifier_names
Widget HomeButton(BuildContext context, String name) {
  Widget? buttonIcon = getButtonIcon(name);
  Color? buttonColor = getButtonColor(name); 
  UserDetails userDetails = UserDetails();
  DashboardDetails dashboardDetails = DashboardDetails();

  return GestureDetector(
    onTap: () async {
      if (name == button_1) {
        Navigator.pushNamed(context, '/profile');
      } else if (name == button_2) {
        await userDetails.fetchAllInfo(context);
      } else if (name == button_3) {
        await dashboardDetails.fetchAllInfo(context);
      } else if (name == button_4) {
        FirebaseService.signOutFromGoogle(context);
      } else if (name == button_5) {
        Navigator.pushNamed(context, '/database');
      }
    },
    child: Container(
      width: 230,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: buttonColor, 
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (buttonIcon != null) buttonIcon, 
          const SizedBox(width: 15),
          Text(
            name,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
