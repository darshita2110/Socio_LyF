import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ added
import '../theme_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;

  // ✅ controllers for input
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ✅ signup function
  Future<void> signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // ✅ success → go to home
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // ✅ failure → show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign Up failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.amber.shade900, Colors.brown.shade800]
                : [Colors.amber.shade200, Colors.orange.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset("assets/images/coder.png", height: 100),
                const SizedBox(height: 20),
                Text(
                  "Create Account",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 30),

                // Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withOpacity(0.5)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController, // ✅ added
                        decoration: InputDecoration(
                          hintText: "Full Name",
                          prefixIcon: Icon(Icons.person,
                              color: Theme.of(context).primaryColor),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: emailController, // ✅ added
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email,
                              color: Theme.of(context).primaryColor),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password with eye
                      TextField(
                        controller: passwordController, // ✅ added
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock,
                              color: Theme.of(context).primaryColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: signUp, // ✅ now runs Firebase signup
                        child: const Text("SIGN UP"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: GoogleFonts.poppins(
                        color: isDark ? Colors.white : Colors.black),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
