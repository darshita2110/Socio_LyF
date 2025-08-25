import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true; // password visibility toggle
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Firebase Login function
  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // if successful, navigate to home
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // show error in a snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset("assets/images/coder.png", height: 100),
                const SizedBox(height: 20),
                Text(
                  "Welcome Back",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 30),

                // Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withOpacity(0.5)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // ✅ Email Controller added
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

                      // ✅ Password Controller added
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
                        onPressed: login, // ✅ call Firebase login
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New user?",
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
