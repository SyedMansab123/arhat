import 'package:arhat/screens/Dashboard/dashboard.dart';
import 'package:arhat/screens/SplashScreen/splash_screen.dart';
import 'package:arhat/screens/Onboboarding/onboarding_view.dart';
import 'package:arhat/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connection_notifier/connection_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding") ?? false;

  runApp(MyApp(onboarding: onboarding));
}

class MyApp extends StatelessWidget {
  final bool onboarding;

  const MyApp({super.key, required this.onboarding});

  @override
  Widget build(BuildContext context) {
    return ConnectionNotifier(
      child: SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ARHAT',
          theme: ThemeData(
            textTheme: GoogleFonts.urbanistTextTheme(),
            primarySwatch: Colors.blue,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const Dashboard();
              } else {
                return onboarding
                    ? const SplashScreen()
                    : const OnboardingView();
              }
            },
          ),
        ),
      ),
    );
  }
}
