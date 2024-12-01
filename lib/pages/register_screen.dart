import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();

  Future<void> saveUsername(String username) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'username': username,
    });
  }
}

  Future<void> _registerUser() async {
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      String passwordNotMatch = "Нууц үгс тохирохгүй байна";

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Алдаа',
                style: TextStyle(color: Colors.red),
              ),
              content: Text(passwordNotMatch),
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await saveUsername(_usernameController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Home()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Энэ имэйл хаяг аль хэдийн бүртгэгдсэн байна.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Имэйл буруу форматтай байна';
      } else {
        errorMessage = 'Бүртгэл үүсгэх үед алдаа гарлаа: ${e.message}';
      }
      
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
              SizedBox(height: 50),

              Text(
                "Орлого зарлагыг хянахад тань тусална",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold
                ),
              ),

              SizedBox(height: 100),

              SizedBox(
                width: 350,
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: "Хэрэглэгчийн нэр",
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

              const SizedBox(height: 10),

              SizedBox(
                width: 350,
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Нууц үг дахин оруулна уу",
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
                onPressed: _registerUser,
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
                  'Бүртгүүлэх',
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
                  Text("Хэрэглэгчийн эрхтэй юу?"),
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
      ),
    );
  }
}
