import '../../utils/imports.dart';

class SingleActionButton extends StatefulWidget {
  final Color color;
  final String buttonName;
  const SingleActionButton({
    super.key,
    required this.color,
    required this.buttonName,
  });

  @override
  State<SingleActionButton> createState() => _SingleActionButtonState();
}

class _SingleActionButtonState extends State<SingleActionButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 150,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget.color,
      ),
      child: Text(
        widget.buttonName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
