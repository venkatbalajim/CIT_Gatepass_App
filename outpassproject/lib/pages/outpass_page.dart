import '../utils/imports.dart';

class OutpassPage extends StatefulWidget {
  const OutpassPage({super.key});

  @override
  State<OutpassPage> createState() => _OutpassPageState();
}

class _OutpassPageState extends State<OutpassPage> {
  String allDetailErr = 'Kindly fill all the details.';
  String timeIntervalErr =
      'Invalid time interval. It should be at least 5 minutes.';
  String dateTimeErr = 'Kindly check out date time and in date time.';

  static String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  OutpassValidation newValidation = OutpassValidation(
      purpose: '',
      outDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      inDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      outTime: _formatTime(TimeOfDay.now()),
      inTime: _formatTime(TimeOfDay.now()),
      checkOutDate: DateTime.now(),
      checkOutTime: TimeOfDay.now(),
      checkInDate: DateTime.now(),
      checkInTime: TimeOfDay.now());

  String todayDate() {
    return DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const Text('Submission Denied'),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            )
          ],
        );
      },
    );
  }

  void showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const Text('Check Outpass'),
          content: Text('''
Submit date: ${todayDate()}
Purpose: ${newValidation.purpose}
Out date: ${newValidation.outDate}
Out time: ${newValidation.outTime}
In date: ${newValidation.inDate}
In time: ${newValidation.inTime}

Are you sure to proceed?
'''),
          actions: [
            TextButton(
                onPressed: () async {
                  SaveOutpassDetails outpassDetails = SaveOutpassDetails(
                    date: todayDate(),
                    purpose: newValidation.purpose,
                    outDate: newValidation.outDate,
                    outTime: newValidation.outTime,
                    inDate: newValidation.inDate,
                    inTime: newValidation.inTime,
                    checkOutDate: newValidation.checkOutDate,
                    checkOutTime: newValidation.checkOutTime,
                    checkInDate: newValidation.checkInDate,
                    checkInTime: newValidation.checkInTime,
                  );
                  await FirestoreService()
                      .saveOutpassDetails(context, outpassDetails);
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                child: Text('Proceed',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            body: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Submit an Outpass",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(13, 71, 161, 1),
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomDropdown(
                    onChanged: (value) {
                      setState(() {
                        newValidation.purpose = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomDatePicker(
                    label: "Out date",
                    onDateChanged: (value, check) {
                      setState(() {
                        newValidation.outDate = value;
                        newValidation.checkOutDate = check;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTimePicker(
                    label: "Out time",
                    onTimeChanged: (value, check) {
                      setState(() {
                        newValidation.checkOutTime = check;
                        newValidation.outTime = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomDatePicker(
                    label: "In date",
                    onDateChanged: (value, check) {
                      setState(() {
                        newValidation.inDate = value;
                        newValidation.checkInDate = check;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTimePicker(
                    label: "In time",
                    onTimeChanged: (value, check) {
                      setState(() {
                        newValidation.checkInTime = check;
                        newValidation.inTime = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SmallButton(
                    name: 'Submit',
                    onTap: () async {
                      if (!newValidation.areDetailsFilled()) {
                        showErrorDialog(context, allDetailErr);
                      } else if (!newValidation.isDateTimeValid()) {
                        showErrorDialog(context, dateTimeErr);
                      } else if (!newValidation.isTimeIntervalValid()) {
                        showErrorDialog(context, timeIntervalErr);
                      } else {
                        showReviewDialog(context);
                      }
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        )),
      ),
    );
  }
}
