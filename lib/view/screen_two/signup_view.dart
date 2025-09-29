import 'package:flutter/material.dart';
import '../../services/firebase_services.dart';


class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _service = FirebaseService();
  bool _loading = false;

  Future<void> _signUp() async {
    setState(() => _loading = true);
    try {
      final user = await _service.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (user != null) {
        if(!mounted)return; 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign Up Successful")),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if(!mounted)return; 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signUp,
                    child: const Text("Sign Up"),
                  ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("Already have an account? Sign In"),
            ),
          ],
        ),
      ),
    );
  }
}
