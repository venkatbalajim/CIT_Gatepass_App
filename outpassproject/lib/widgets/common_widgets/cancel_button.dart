import '../../utils/imports.dart';

class CancelButton extends StatefulWidget {
  final String name;
  final VoidCallback onTap;

  const CancelButton({
    super.key,
    required this.name,
    required this.onTap,
  });

  @override
  State<CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        width: 150,
        height: 40,
        child: Text(
          widget.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
