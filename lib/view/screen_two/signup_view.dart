import 'package:flutter/material.dart';
import 'package:test_project/utils/router.dart';
import 'package:test_project/view/screen_two/login_view.dart';

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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginView()));
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
      backgroundColor: Colors.grey[100],
      
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              Center(
                child: const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _signUp,
                      child: const Text("Sigup"),
                    ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  AppRouter.pushReplacement(
                     LoginView(),
                  );
                },
                child: const Text("Already have an account? Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
    // Scaffold(
    //   appBar: AppBar(title: const Text("Sign Up"),automaticallyImplyLeading: false, centerTitle: true,),
      
    //   body: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       children: [
    //         TextField(
    //           controller: _emailController,
    //           decoration: const InputDecoration(labelText: "Email"),
    //         ),
    //         const SizedBox(height: 10),
    //         TextField(
    //           controller: _passwordController,
    //           obscureText: true,
    //           decoration: const InputDecoration(labelText: "Password"),
    //         ),
    //         const SizedBox(height: 20),
    //         _loading
    //             ? const CircularProgressIndicator()
    //             : ElevatedButton(
    //                 onPressed: _signUp,
    //                 child: const Text("Sign Up"),
    //               ),
    //         TextButton(
    //           onPressed: () {
    //             Navigator.pushReplacementNamed(context, '/login');
    //           },
    //           child: const Text("Already have an account? Sign In"),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  
  }
}
