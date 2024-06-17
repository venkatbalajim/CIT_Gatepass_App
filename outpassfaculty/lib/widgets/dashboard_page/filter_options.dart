import '../../utils/imports.dart';

class FilterOptions extends StatefulWidget {
  final Function(String) onOptionSelected;
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

  @override
  void initState() {
    super.initState();
    _loadSelectedOption();
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
                  ...List.generate(
                    options.length,
                    (index) {
                      return RadioListTile<String>(
                        activeColor: Theme.of(context).colorScheme.primary,
                        title: Text(options[index],
                            style: const TextStyle(fontSize: 15)),
                        value: options[index],
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value!;
                            _saveSelectedOption(selectedValue);
                          });
                          widget.onOptionSelected(selectedValue);
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
                      const SizedBox(
                        width: 10,
                      ),
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
