import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pages/get_started.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/home_page.dart';
import 'theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SocioLyF',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: const Color(0xFFFFB300),
        scaffoldBackgroundColor: Colors.yellow.shade50,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFB300),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        primaryColor: const Color(0xFFFF8F00),
        scaffoldBackgroundColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF8F00),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      initialRoute: '/getStarted',
      routes: {
        '/getStarted': (context) => const GetStartedPage(),
        '/login': (context) => LoginPage(), // remove const if passing arguments
        '/signup': (context) => SignUpPage(),
        // remove '/home' from routes because HomePage needs userId
      },
      // Optional: handle redirect after login/signup here using onGenerateRoute
    );
  }
}

// Example: Redirect to HomePage after login/signup
void navigateToHome(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(userId: user.uid),
      ),
    );
  }
}
