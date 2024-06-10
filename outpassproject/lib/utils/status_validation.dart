import '../utils/imports.dart';

class StatusValidation {
  String currentStatus(int status) {
    if (status == 0) {
      return "Pending";
    } else if (status == -1) {
      return "Declined";
    } else if (status == 1) {
      return "Approved";
    } else if (status == 10) {
      return "No Need";
    }
    return "Error occurred";
  }

  int? checkStatus(int a, int b, int c) {
    if (a == -1 || b == -1 || c == -1) {
      return -1;
    }
    if (a == 10) a = 1;
    if (b == 10) b = 1;
    if (a == b && b == c && c == a && a == 1) {
      return 1;
    } else if (a == 0 || b == 0 || c == 0) {
      return 0;
    }
    return null;
  }

  String? outpassStatus(int a, int b, int c) {
    if (a == -1 || b == -1 || c == -1) {
      return "Declined";
    }
    if (a == 10) a = 1;
    if (b == 10) b = 1;
    if (a == b && b == c && c == a && a == 1) {
      return "Approved";
    } else if (a == 0 || b == 0 || c == 0) {
      return "Pending";
    }
    return null;
  }

  String? buttonName(int a, int b, int c) {
    if (checkStatus(a, b, c) == 1) {
      return "Get QR Code";
    } else if (a == -1 || b == -1 || c == -1) {
      return "New Outpass";
    } else if (a == 0 || b == 0 || c == 0) {
      return "Go to Home";
    }
    return null;
  }

  void nextPage(BuildContext context, int? check, String docId) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? currentUserEmail = user!.email;
    UserDetails userDetails = UserDetails();

    if (check == 1) {
      final document = await userDetails.getUserDetails(currentUserEmail!);
      if (document != null) {
        final userDocumentReference = document.reference;
        userDocumentReference.update({
          'is_submitted': 2,
          'depart_status': 0,
          'arrival_status': 0,
        }).whenComplete(() => // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                )));
      }
    } else if (check == 0) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
    } else if (check == -1) {
      final document = await userDetails.getUserDetails(currentUserEmail!);

      if (document != null) {
        final userDocumentReference = document.reference;

        userDocumentReference.update({
          'submit_date': FieldValue.delete(),
          'purpose': FieldValue.delete(),
          'out_date': FieldValue.delete(),
          'out_time': FieldValue.delete(),
          'in_date': FieldValue.delete(),
          'in_time': FieldValue.delete(),
          'advisor_status': FieldValue.delete(),
          'hod_status': FieldValue.delete(),
          'warden_status': FieldValue.delete(),
          'is_submitted': FieldValue.delete(),
          'arrival_status': FieldValue.delete(),
          'depart_status': FieldValue.delete(),
          'check_out_date': FieldValue.delete(),
          'check_out_time': FieldValue.delete(),
          'check_in_date': FieldValue.delete(),
          'check_in_time': FieldValue.delete(),
          'outpass_status': FieldValue.delete(),
          'depart_date': FieldValue.delete(),
          'depart_time': FieldValue.delete(),
          'arrival_date': FieldValue.delete(),
          'arrival_time': FieldValue.delete(),
        }).whenComplete(() => // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                )));
      }
    }
  }
}
