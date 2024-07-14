import '../../utils/imports.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? preValue;

  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.preValue,
  });

  @override
  Widget build(BuildContext context) {
    if (preValue != null) {
      controller.text = preValue!;
    }

    return SizedBox(
      child: TextField(
        cursorColor: Colors.blue[900],
        cursorWidth: 2,
        controller: controller,
        style: const TextStyle(
          fontSize: 15,
        ),
        decoration: InputDecoration(
          label: Text(hintText),
          floatingLabelStyle: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(13, 71, 161, 1),
              width: 2,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
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
