import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'), 
            fit: BoxFit.contain,
            alignment: Alignment.topCenter, 
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              height: 500, 
              child: Center(
                child: Image.asset('assets/images/onboarding_image.png'),
              ),
            ),
            const Text(
              'Ухаалаг Зарцуулж Илүү Хэмнэе',
              style: TextStyle(
                fontSize: 40, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF438883)
                ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3E7C78),
                minimumSize: Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), 
                  side: BorderSide(
                    color: Colors.white, 
                    width: 2, 
                  ),
                ),
              ),
              child: const Text(
                'Эхлэх',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                  ), 
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Хэрэглэгчийн эрх бий юу?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  },
                  style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF438883), 
                      ),
                  child: const Text('Нэвтрэх'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
