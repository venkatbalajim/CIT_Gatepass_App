import '../utils/imports.dart';

class QRValidation {
  String departureStatus(int status) {
    if (status == 1) {
      return "Yes";
    }
    return "No";
  }

  String arrivalStatus(int status) {
    if (status == 1) {
      return "Yes";
    }
    return "No";
  }

  void eraseAll(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? currentUserEmail = user!.email;
    UserDetails userDetails = UserDetails();
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
      }).whenComplete(() => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage())));
    }
  }
}
