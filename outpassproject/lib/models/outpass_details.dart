import '../utils/imports.dart';

class SaveOutpassDetails {

  final String date;
  final String purpose;
  final String outDate;
  final String outTime;
  final String inDate;
  final String inTime;
  final DateTime checkOutDate;
  final TimeOfDay checkOutTime;
  final DateTime checkInDate;
  final TimeOfDay checkInTime;

  SaveOutpassDetails({
    required this.date,
    required this.purpose,
    required this.outDate,
    required this.outTime,
    required this.inDate,
    required this.inTime,
    required this.checkOutDate,
    required this.checkOutTime,
    required this.checkInDate,
    required this.checkInTime
  });

}
