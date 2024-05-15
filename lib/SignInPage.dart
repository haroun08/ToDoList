import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './home.dart'; // Import the Home page

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sign In Failed'),
              content: Text('Please enter both email and password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('User signed in: ${userCredential.user?.email}');

      // Redirect to the home page
      Navigator.pushReplacementNamed(context, '/'); // Use pushReplacementNamed to prevent going back
    } catch (error) {
      print('Failed to sign in with email and password: $error');
      String errorMessage = 'An error occurred. Please try again.';
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'user-not-found':
            errorMessage = 'User not found. Please check your email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password. Please try again.';
            break;
          default:
            errorMessage = 'An error occurred. Please try again.';
            break;
        }
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sign In Failed'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _goToSignUp(BuildContext context) {
    Navigator.pushNamed(context, '/signUp');
  }

  void _resetPassword(BuildContext context) {
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reset Password Failed'),
            content: Text('Please enter your email address.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    _auth.sendPasswordResetEmail(email: email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Reset Email Sent'),
          content: Text(
              'An email has been sent to $email with instructions to reset your password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFBF6F6), // Set background color
        ),
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/aidhub.png', // Add the image here
              height: 150,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _signInWithEmailAndPassword(context),
              child: Text('Sign In'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF72F2EB),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () => _goToSignUp(context),
              child: Text('Don\'t have an account? Sign up'),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () => _resetPassword(context),
              child: Text('Forgot password?'),
            ),
          ],
        ),
      ),
    );
  }
}