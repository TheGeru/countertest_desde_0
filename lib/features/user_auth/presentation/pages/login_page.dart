import 'package:countertest/features/user_auth/presentation/pages/home_page.dart';
import 'package:countertest/features/user_auth/presentation/repository/user_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:countertest/features/user_auth/presentation/pages/sing_up_page.dart';
import 'package:countertest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  final UserAuthRepository userAuthRepository;

  const LoginPage({super.key, required this.userAuthRepository});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final UserAuthRepository userAuthRepository =
        FirebaseAuthRepository(firebaseAuth: firebaseAuth);
    ValueNotifier userCredential = ValueNotifier('');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter con firebase"),
      ),
      backgroundColor: Color.fromARGB(255, 95, 19, 218),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Iniciar Sesion",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Correo Electrónico",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Contraseña",
                isPasswordField: true,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _errorMessage = null;
                  });
                  final String email = _emailController.text;
                  final String password = _passwordController.text;

                  try {
                    await widget.userAuthRepository
                        .loginUser(email: email, password: password);
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      _errorMessage = e.message;
                    });
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Text(
                  "Iniciar Sesion",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 15), // Añade un espacio de 15 de alto
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () async {
                    userCredential.value = await signInWithGoogle();
                    if (userCredential.value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white, // Puedes cambiar esto al color que desees
                      ),
                   ),
                  child: const Text(
                    'Inicia con Google',
                    style: TextStyle(
                      color: Color(0xff142047),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No tienes cuenta?"),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage(
                                    userAuthRepository: userAuthRepository)),
                            (route) => false);
                      },
                      child: const Text(
                        "Registro",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // El usuario canceló la autenticación con Google.
      return null;
    }

    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    if (googleAuth == null) {
      // No se pudo obtener la autenticación de Google.
      return null;
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on FirebaseAuthException catch (e) {
    final String errorMessage =
        'Error de autenticación de Firebase: ${e.code} - ${e.message}';
    debugPrint(errorMessage);
    throw errorMessage;
  } catch (e) {
    debugPrint('Error desconocido al autenticar con Google: $e');
    throw 'Error desconocido al autenticar con Google';
  }
}
