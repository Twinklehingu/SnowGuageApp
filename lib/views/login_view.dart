import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  final FirebaseAuth auth;
  const LoginView({super.key, required this.auth});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _firebaseErrorCode;

  void _onSignUp() async {
    try {
      await widget.auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        _firebaseErrorCode = null;
      });
    } on FirebaseAuthException catch (ex) {
      print(ex.code);
      print(ex.message);
      setState(() {
        _firebaseErrorCode = ex.code;
      });
    }
  }

  void _onSignIn() async {
    try {
      await widget.auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to the home screen or perform necessary actions upon successful sign-in
    } on FirebaseAuthException catch (ex) {
      print(ex.code);
      print(ex.message);
      setState(() {
        _firebaseErrorCode = ex.code;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('SnowGauge',
            style: TextStyle(fontSize: 56),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _onSignUp,
              child: const Text('Sign up'),
            ),
            ElevatedButton(
              onPressed: _onSignIn,
              child: const Text('Sign in'),
            ),
            if (_firebaseErrorCode != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  _firebaseErrorCode!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
