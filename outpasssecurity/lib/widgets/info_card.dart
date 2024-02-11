import '../../utils/imports.dart';

class InfoCard extends StatelessWidget {

  final String label;
  final dynamic detail;

  const InfoCard({super.key, required this.label, required this.detail});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, 
            style: const TextStyle(
              fontSize: 17,
              color: Color.fromARGB(255, 38, 17, 197),
            ),
          ),
          Text(detail.toString(), 
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
