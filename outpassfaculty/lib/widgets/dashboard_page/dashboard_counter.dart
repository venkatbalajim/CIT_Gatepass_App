import '../../utils/imports.dart';

class DashboardCounter extends StatelessWidget {
  final int countOne;
  final int countTwo;
  final  String titleOne;
  final  String titleTwo;
  const DashboardCounter({
    super.key, required this.countOne, 
    required this.countTwo, 
    required this.titleOne, required this.titleTwo, 
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("$countOne", textAlign: TextAlign.center, style: const TextStyle(fontSize: 30),),
            const SizedBox(height: 10,),
            SizedBox(
              width: 100,
              child: Text(titleOne, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15),),
            )
          ],
        ),
        const SizedBox(width: 15,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("$countTwo", textAlign: TextAlign.center, style: const TextStyle(fontSize: 30),),
            const SizedBox(height: 10,),
            SizedBox(
              width: 100,
              child: Text(titleTwo, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15),),
            )
          ],
        ),
        const SizedBox(width: 10,),
      ],
    );
  }
}

class AdvisorDashboardCounter extends StatelessWidget {
  final int countOne;
  final int countTwo;
  const AdvisorDashboardCounter({
    super.key, 
    required this.countOne, 
    required this.countTwo, 
  });

  @override
  Widget build(BuildContext context) {
    return DashboardCounter(
      countOne: countOne, 
      countTwo: countTwo, 
      titleOne: "Departure Count", 
      titleTwo: "Arrival Count", 
    );
  }
}

class HodDashboardCounter extends StatelessWidget {
  final int countOne;
  final int countTwo;
  const HodDashboardCounter({
    super.key, 
    required this.countOne, 
    required this.countTwo, 
  });

  @override
  Widget build(BuildContext context) {
    return DashboardCounter(
      countOne: countOne, 
      countTwo: countTwo, 
      titleOne: "Departure Count", 
      titleTwo: "Arrival Count", 
    );
  }
}

class WardenDashboardCounter extends StatelessWidget {
  final int countOne;
  final int countTwo;
  const WardenDashboardCounter({
    super.key, 
    required this.countOne, 
    required this.countTwo, 
  });

  @override
  Widget build(BuildContext context) {
    return DashboardCounter(
      countOne: countOne, 
      countTwo: countTwo, 
      titleOne: "Departure Count", 
      titleTwo: "Arrival Count", 
    );
  }
}

class PrincipalDashboardCounter extends StatelessWidget {
  final int countOne;
  final int countTwo;
  const PrincipalDashboardCounter({
    super.key, 
    required this.countOne, 
    required this.countTwo, 
  });

  @override
  Widget build(BuildContext context) {
    return DashboardCounter(
      countOne: countOne, 
      countTwo: countTwo, 
      titleOne: "Departure Count", 
      titleTwo: "Arrival Count", 
    );
  }
}
