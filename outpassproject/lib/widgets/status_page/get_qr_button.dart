import '../../utils/imports.dart';

class GetQRButton extends StatefulWidget {
  final String name;
  final VoidCallback onTap;

  const GetQRButton({
    super.key,
    required this.name,
    required this.onTap,
  });

  @override
  State<GetQRButton> createState() => _GetQRButtonState();
}

class _GetQRButtonState extends State<GetQRButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green[700],
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
