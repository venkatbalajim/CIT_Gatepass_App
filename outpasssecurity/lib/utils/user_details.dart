import '../utils/imports.dart';

class UserDetails {
  Future<String> fetchSecurityInformation(String fieldName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String documentId = "security-information";

    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection("security").doc(documentId).get();

      if (documentSnapshot.exists) {
        final securityInfo = documentSnapshot.data();
        String fieldValue = securityInfo?[fieldName] ?? 0;
        return fieldValue;
      }

      throw Exception("Document 'security-information' does not exist");
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> fetchStudentOutpass(String value) async {
    final userCollection = FirebaseFirestore.instance.collection('users');

    try {
      final userQuery = await userCollection.doc(value).get();
      return userQuery.data();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> fetchPassword() async {
    return fetchSecurityInformation('password');
  }

  Future<String> fetchPhoneNo() async {
    return fetchSecurityInformation('phone_no');
  }
}
