// ignore_for_file: use_build_context_synchronously

import '../../utils/imports.dart';

const button_1 = "Profile";
const button_2 = "Outpass";
const button_3 = "Dashboard";
const button_4 = "Logout";
const button_5 = "Database";

const button_6 = "Students";
const button_7 = "Faculty";
const button_8 = "Warden";
const button_9 = "Security";

Widget? getButtonIcon(String name) {
  switch (name) {
    case button_1:
      return const Icon(
        Icons.person,
        color: Colors.white,
        size: 35,
      );
    case button_2:
      return const Icon(
        Icons.assignment,
        color: Colors.white,
        size: 35,
      );
    case button_3:
      return const Icon(
        Icons.dashboard,
        color: Colors.white,
        size: 35,
      );
    case button_4:
      return const Icon(
        Icons.logout,
        color: Colors.white,
        size: 35,
      );
    case button_5:
      return const Icon(
        Icons.storage,
        color: Colors.white,
        size: 35,
      );
    case button_6:
      return const Icon(
        Icons.school,
        color: Colors.white,
        size: 35,
      );
    case button_7:
      return const Icon(
        Icons.work,
        color: Colors.white,
        size: 35,
      );
    case button_8:
      return const Icon(
        Icons.person,
        color: Colors.white,
        size: 35,
      );
    case button_9:
      return const Icon(
        Icons.verified_user,
        color: Colors.white,
        size: 35,
      );
    default:
      return null;
  }
}

Color? getButtonColor(BuildContext context, String name) {
  return Theme.of(context).colorScheme.primary;
}

// ignore: non_constant_identifier_names
Widget GridButton(BuildContext context, String name) {
  Widget? buttonIcon = getButtonIcon(name);
  Color? buttonColor = getButtonColor(context, name);
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
        Navigator.pushNamed(context, '/selectdb');
      } else if (name == button_6) {
        Navigator.pushNamed(context, '/students');
      } else if (name == button_7) {
        Navigator.pushNamed(context, '/faculty');
      } else if (name == button_8) {
        Navigator.pushNamed(context, '/warden');
      } else if (name == button_9) {
        Navigator.pushNamed(context, '/security');
      } else {
        return;
      }
    },
    child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: buttonColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (buttonIcon != null) buttonIcon,
          const SizedBox(height: 10),
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
