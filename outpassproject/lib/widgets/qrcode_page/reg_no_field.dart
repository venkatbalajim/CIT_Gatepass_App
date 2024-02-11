import '../../utils/imports.dart';

class RegNoField extends StatefulWidget {
  final TextEditingController qrDataController;
  final Function(String) onDataChanged;

  const RegNoField({
    super.key,
    required this.qrDataController,
    required this.onDataChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RegNoFieldState createState() => _RegNoFieldState();
}

class _RegNoFieldState extends State<RegNoField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: TextField(
        style: const TextStyle(
          fontSize: 18,
        ),
        cursorColor: Colors.blue[900],
        controller: widget.qrDataController,
        onChanged: (value) {
          widget.onDataChanged(value);
        },
        textAlign: TextAlign.center,
        focusNode: _focusNode,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Reg No - Eg: 22CS001',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(13, 71, 161, 1),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
