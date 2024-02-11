import '../../utils/imports.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  State<GoogleSignInButton> createState() => GoogleSignInButtonState();
}

class GoogleSignInButtonState extends State<GoogleSignInButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FirebaseService.signInwithGoogle(context);  
      },
      child: Container(
        width: 250,
        height: 50,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border(
            bottom: BorderSide(color: Color.fromARGB(255, 91, 91, 91), width: 1.5),
            top: BorderSide(color: Color.fromARGB(255, 91, 91, 91), width: 1.5),
            left: BorderSide(color: Color.fromARGB(255, 91, 91, 91), width: 1.5),
            right: BorderSide(color: Color.fromARGB(255, 91, 91, 91), width: 1.5),
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("images/google_logo.png",
              width: 22,
              height: 22,
            ),
            const SizedBox(width: 15,),
            Text("Continue with Google", 
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
