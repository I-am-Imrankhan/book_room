import 'package:book_room/screens/singup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_room/providers/AuthProvider.dart' as auth_provider;
import 'home_screen.dart';
import 'package:book_room/widgets/custom_text_field.dart';
import 'package:book_room/widgets/custom_button.dart';
import 'package:book_room/widgets/error_message.dart';
import 'package:book_room/widgets/button_link.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? errorMessage;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<auth_provider.AuthProvider>(context, listen: false);
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final result = await authProvider.signIn(email, password);
        if (result != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Failed to sign in: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: _signIn,
                text: 'Login',
                color: Colors.blue,
                textColor: Colors.white,
                borderColor: Colors.green,
                size: const Size(200, 50),
              ),
              const SizedBox(height: 20),
              ButtonLink(
                text: "Don't have an account? Sign up",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignupScreen()),
                  );
                },
                color: Colors.blue,
                textDecoration: TextDecoration.underline,
              ),
              const SizedBox(height: 20),
              if (errorMessage != null)
                ErrorMessage(
                  message: errorMessage!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}