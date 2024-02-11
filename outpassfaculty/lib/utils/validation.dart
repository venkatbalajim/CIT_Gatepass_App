// ignore_for_file: avoid_print

import 'imports.dart';

Future<void> updateAdvisorStatus(String documentId, int advisorStatus) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('users').doc(documentId).update({
      'advisor_status': advisorStatus,
    }).whenComplete(() => print('Document updated successfully'));
  } catch (error) {
    print('Error updating document: $error');
  }
}

Future<void> updateHodStatus(String documentId, int hodStatus) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('users').doc(documentId).update({
      'hod_status': hodStatus,
    }).whenComplete(() => print('Document updated successfully'));
  } catch (error) {
    print('Error updating document: $error');
  }
}

Future<void> updateWardenStatus(String documentId, int wardenStatus) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('users').doc(documentId).update({
      'warden_status': wardenStatus,
    });
    print('Document updated successfully');
  } catch (error) {
    print('Error updating document: $error');
  }
}

Future<void> noNeedUpdateStatus(String documentId, int noNeedStatus) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('users').doc(documentId).update({
      'advisor_status': noNeedStatus,
      'hod_status': noNeedStatus
    });
    print('Document updated successfully');
  } catch (error) {
    print('Error updating document: $error');
  }
}
