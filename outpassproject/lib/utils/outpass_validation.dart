import '../utils/imports.dart';

class OutpassValidation {

  late String purpose = '';
  late String outDate = '';
  late String inDate = '';
  late String outTime = '';
  late String inTime = '';
  late DateTime checkOutDate = DateTime.now();
  late DateTime checkInDate = DateTime.now();
  late TimeOfDay checkOutTime = TimeOfDay.now();
  late TimeOfDay checkInTime = TimeOfDay.now();

  OutpassValidation({
    required this.purpose,
    required this.outDate,
    required this.inDate,
    required this.outTime,
    required this.inTime,
    required this.checkOutDate,
    required this.checkOutTime,
    required this.checkInDate,
    required this.checkInTime
  });

  bool areDetailsFilled() {
    return purpose.isNotEmpty &&
        outDate.isNotEmpty &&
        outTime.isNotEmpty &&
        inDate.isNotEmpty &&
        inTime.isNotEmpty;
  }

  bool isDateTimeValid() {
    DateTime currentTime = DateTime.now();
    DateTime checkOutDateTime = DateTime(checkOutDate.year, checkOutDate.month, checkOutDate.day, checkOutTime.hour, checkOutTime.minute);
    DateTime checkInDateTime = DateTime(checkInDate.year, checkInDate.month, checkInDate.day, checkInTime.hour, checkInTime.minute);

    return checkInDateTime.isAfter(checkOutDateTime) && 
        checkInDateTime.isAfter(currentTime) &&
        checkOutDateTime.isAfter(currentTime);
  }

  bool isTimeIntervalValid() {
    DateTime checkOutDateTime = DateTime(
      checkOutDate.year,
      checkOutDate.month,
      checkOutDate.day,
      checkOutTime.hour,
      checkOutTime.minute,
    );
    DateTime checkInDateTime = DateTime(
      checkInDate.year,
      checkInDate.month,
      checkInDate.day,
      checkInTime.hour,
      checkInTime.minute,
    );

    if (checkInDateTime.isAfter(checkOutDateTime)) {
      int timeDifference = checkInDateTime.difference(checkOutDateTime).inMinutes;
      return timeDifference >= 5;
    }
    return false;
  }

}
