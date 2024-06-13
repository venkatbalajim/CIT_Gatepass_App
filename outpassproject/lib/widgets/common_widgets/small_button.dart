import '../../utils/imports.dart';

class SmallButton extends StatefulWidget {
  final String name;
  final VoidCallback onTap;

  const SmallButton({
    super.key,
    required this.name,
    required this.onTap,
  });

  @override
  State<SmallButton> createState() => _SmallButtonState();
}

class _SmallButtonState extends State<SmallButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary,
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
