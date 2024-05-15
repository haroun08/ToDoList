import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
    try {
      if (_passwordController.text != _confirmPasswordController.text) {
        // Passwords do not match
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sign Up Failed'),
              content: Text('Passwords do not match. Please try again.'),
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

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // User successfully signed up
      // Now you can send additional user information to Firestore or perform other actions

      // Example: Sending additional user information to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': _emailController.text.trim(),
        'organization': _organizationController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        // Add more fields as needed
      });

      // Navigate to home page or perform other actions upon successful sign-up
      Navigator.pushNamed(context, '/home');
    } catch (error) {
      // Handle sign-up failure
      print('Failed to sign up with email and password: $error');
      // Show error message to user if needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sign Up Failed'),
            content: Text('An error occurred during sign up. Please try again.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        color: Color(0xFFFBF6F6), // Set background color
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20), // Add space from top
                Container(
                  height: 100, // Adjust the height of the container
                  width: 100, // Adjust the width of the container
                  child: Image.asset('images/aidhub.png'), // Add aidhub.png as logo
                ),
                SizedBox(height: 20), // Add space between logo and text fields
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7), // Add background color for text field
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7), // Add background color for text field
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7), // Add background color for text field
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _organizationController,
                  decoration: InputDecoration(
                    labelText: 'Organization Name',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7), // Add background color for text field
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7), // Add background color for text field
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () => _signUpWithEmailAndPassword(context),
                  child: Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF72F2EB),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40), // Adjust padding
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
