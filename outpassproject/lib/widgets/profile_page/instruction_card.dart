import '../../utils/imports.dart';

class InstructionCard extends StatelessWidget {
  final String instruction;
  const InstructionCard({super.key, required this.instruction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.amber[200],
      ),
      child: Text(instruction, 
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.amber[900],
        ),
      ),
    );
  }
}
