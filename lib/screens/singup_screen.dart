import 'package:book_room/screens/home_screen.dart';
import 'package:book_room/services/auth_service.dart' as auth_service;
import 'package:book_room/widgets/button_link.dart';
import 'package:book_room/widgets/custom_button.dart';
import 'package:book_room/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_room/providers/AuthProvider.dart' as auth_provider;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? errorMessage;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      final authService =
          Provider.of<auth_provider.AuthProvider>(context, listen: false);
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final result = await authService.signUp(email, password);
        if (result != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        } else {
          setState(() {
            errorMessage = "Something went wrong while signup, please again.";
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Sign-up failed: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your email' : null,
              ),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your password' : null,
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: _signUp,
                text: 'Sign Up',
                color: Colors.blue,
                textColor: Colors.white,
                borderColor: Colors.green,
                size: const Size(200, 50),
              ),
              ButtonLink(onPressed: () => Navigator.pop(context), text: "Already have an account? Log in")
            ],
          ),
        ),
      ),
    );
  }
}
