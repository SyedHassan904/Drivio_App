import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:file_manager/Providers/AuthProvider/auth_provider.dart';
import 'package:file_manager/Screens/Auth/login_screen.dart';
import 'package:file_manager/Screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget? _nextScreen;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkLoginAndSetNextScreen();
  }

  Future<void> _checkLoginAndSetNextScreen() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.fethPrefernces();

      if (!mounted) return;

      setState(() {
        _nextScreen = authProvider.isLogin
            ? const MainScreen()
            : const LoginPage();
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to initialize: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error if any
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _error = null;
                      _nextScreen = null;
                    });
                    _checkLoginAndSetNextScreen();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Show loading while checking login
    if (_nextScreen == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/icons/files.json', 
                width: 200, 
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Loading...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
return AnimatedSplashScreen(
  splash: Lottie.asset(
    "assets/icons/filemanager.json",
    fit: BoxFit.contain,
  ),
  nextScreen: _nextScreen!,
  splashTransition: SplashTransition.fadeTransition,
  backgroundColor: Colors.white,
  duration: 3000,
  animationDuration: const Duration(milliseconds: 800),
  splashIconSize: 500, // <-- Increase this to make it bigger
);
  }
}