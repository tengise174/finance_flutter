import 'package:finance_app/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _loginUser() async {

    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Алдаа',
                style: TextStyle(color: Colors.red),
              ),
              content: Text("Имэйл болон нууц үгээ оруулна уу"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
    return;
  }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Home()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Имэйл эсвэл нууц үг буруу';

          // if (e.code == 'user-not-found') {
          //     errorMessage = 'No user found for that email.';
          //   } else if (e.code == 'wrong-password') {
          //     errorMessage = 'Wrong password provided for that user.';
          //   } else {
          //     errorMessage = 'Error: ${e.message}';
          //   }

          showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Алдаа',
                style: TextStyle(color: Colors.red),
              ),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/log_background.png'), 
            fit: BoxFit.contain,
            alignment: Alignment.topCenter, 
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 100),
              Text(
                "Тавтай морилно уу!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),

              Container(
                height: 300,
                child: Center(
                  child: Image.asset('assets/images/human.png'),
                ),
              ),

              SizedBox(
                width: 350,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: "Имэйлээ оруулна уу",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w300, 
                        color: Colors.grey, 
                      ),
                    fillColor: Color.fromARGB(255, 242, 244, 245), 
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                    ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: 350,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Нууц үг оруулна уу",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w300, 
                        color: Colors.grey,
                      ),
                    fillColor: Color.fromARGB(255, 242, 244, 245), 
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                    ),
                ),
              ),

              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: _loginUser,
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
                  'Нэвтрэх',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ), 
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Бүртгүүлэх"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF438883), 
                    ),
                    child: const Text('Бүртгүүлэх'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
