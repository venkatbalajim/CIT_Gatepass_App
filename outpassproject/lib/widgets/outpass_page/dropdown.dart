import '../../utils/imports.dart';

class CustomDropdown extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const CustomDropdown({super.key, required this.onChanged});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String selectedOption = 'Home';
  TextEditingController customPurposeController = TextEditingController();
  bool showTextField = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Purpose',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 17),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromRGBO(13, 71, 161, 1),
                      width: 2,
                    )),
                child: DropdownButton<String>(
                  value: selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue!;
                      showTextField = (newValue == 'Others');
                      widget.onChanged(newValue);
                    });
                  },
                  items: <String>[
                    'Home',
                    'Outing',
                    'Competition',
                    'Workshop',
                    'Hospital',
                    'Others',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  underline: Container(),
                ),
              )
            ],
          ),
          if (showTextField)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                cursorColor: Theme.of(context).colorScheme.primary,
                controller: customPurposeController,
                onChanged: widget.onChanged,
                inputFormatters: [LengthLimitingTextInputFormatter(15)],
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromRGBO(13, 71, 161, 1),
                    width: 2,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromRGBO(13, 71, 161, 1),
                    width: 2,
                  )),
                  hintText: 'Enter the purpose',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
