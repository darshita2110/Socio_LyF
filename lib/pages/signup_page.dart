import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme_provider.dart';
import 'home_page.dart'; // import HomePage

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Firebase signup
  Future<void> signUp() async {
    if (nameController.text.trim().isEmpty) {
      showCustomDialog("Please enter your full name", isError: true);
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // ✅ Redirect to HomePage with userId
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(userId: userCredential.user!.uid),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'email-already-in-use') {
        message = 'This email is already in use.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format.';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak.';
      } else {
        message = 'Sign Up failed: ${e.message}';
      }
      showCustomDialog(message, isError: true);
    }
  }

  // Custom popup dialog
  void showCustomDialog(String message,
      {required bool isError, VoidCallback? onOk}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Popup",
      pageBuilder: (_, __, ___) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: isError ? Colors.red : Colors.green,
                  size: 50,
                ),
                const SizedBox(height: 15),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isError
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (onOk != null) onOk();
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          ),
        ),
      ),
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(scale: anim, child: child),
        );
      },
    );
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
                        controller: nameController,
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
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email,
                              color: Theme.of(context).primaryColor),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
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
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: signUp,
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
