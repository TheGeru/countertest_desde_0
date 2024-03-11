//import 'package:countertest/pages/home_page.dart';
import 'package:countertest/features/app/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:countertest/features/user_auth/presentation/repository/user_auth_repository.dart';
import 'package:countertest/features/user_auth/presentation/pages/sing_up_page.dart';
import 'package:countertest/features/user_auth/presentation/pages/login_page.dart';
import 'package:countertest/features/user_auth/presentation/pages/home_page.dart';
import 'package:countertest/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final UserAuthRepository userAuthRepository =
        FirebaseAuthRepository(firebaseAuth: firebaseAuth);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => SplashScreen(
              child: LoginPage(userAuthRepository: userAuthRepository),
            ),
        '/login': (context) => LoginPage(userAuthRepository: userAuthRepository),
        '/home': (context) => const HomePage(),
        '/signUp': (context) =>
            SignUpPage(userAuthRepository: userAuthRepository),
      },
    );
  }
}
