import '../utils/imports.dart';

class PrincipalPage extends StatefulWidget {
  final List<DocumentSnapshot<Map<String, dynamic>>>? documents;
  const PrincipalPage({super.key, this.documents});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
