import '../../utils/imports.dart';

class FilterOptions extends StatefulWidget {
  final Function(String, String) onOptionSelected;
  final String position;

  const FilterOptions({
    super.key,
    required this.onOptionSelected,
    required this.position,
  });

  @override
  State<FilterOptions> createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  late String selectedValue;
  List<String> options = ['All Details', 'Arrived', 'Not Yet Arrived'];
  List<String> sections = ['All Sections', 'A', 'B', 'C']; // Add 'All Sections' to the list

  late String selectedSection;

  @override
  void initState() {
    super.initState();
    _loadSelectedOption();
    _loadSelectedSection();
  }

  void _loadSelectedOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedValue = prefs.getString('selectedOption') ?? 'All Details';
    });
  }

  void _saveSelectedOption(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedOption', value);
  }

  void _loadSelectedSection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedSection = prefs.getString('selectedSection') ?? 'All Sections'; // Default to 'All Sections'
    });
  }

  void _saveSelectedSection(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedSection', value);
  }

  void _resetOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('selectedOption');
    prefs.remove('selectedSection');
    setState(() {
      selectedValue = 'All Details';
      selectedSection = 'All Sections';
    });
    widget.onOptionSelected(selectedValue, selectedSection);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list_rounded, size: 30),
      onPressed: () {
        _showRadioDialog(context);
      },
    );
  }

  void _showRadioDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              title: const Text('Apply filters'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10,),
                  const Text('Based on arrival status:', style: TextStyle(fontSize: 18),),
                  ...List.generate(
                    options.length,
                    (index) {
                      return RadioListTile<String>(
                        activeColor: Colors.blue[900],
                        title: Text(options[index], style: const TextStyle(fontSize: 15)),
                        value: options[index],
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value!;
                            _saveSelectedOption(selectedValue);
                          });
                          widget.onOptionSelected(selectedValue, selectedSection);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  if (widget.position != 'Faculty - Class Advisor')
                    const Text('Based on sections:', style: TextStyle(fontSize: 18),),
                  ...List.generate(
                    sections.length,
                    (index) {
                      return RadioListTile<String>(
                        activeColor: Colors.blue[900],
                        title: Text(sections[index], style: const TextStyle(fontSize: 15)),
                        value: sections[index],
                        groupValue: selectedSection,
                        onChanged: (value) {
                          setState(() {
                            selectedSection = value!;
                            _saveSelectedSection(selectedSection);
                          });
                          widget.onOptionSelected(selectedValue, selectedSection);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        child: SmallButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          name: 'Apply',
                        ),
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 80,
                        child: SmallButton(
                          onTap: () {
                            _resetOptions();
                            Navigator.pop(context);
                          },
                          name: 'Reset',
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
