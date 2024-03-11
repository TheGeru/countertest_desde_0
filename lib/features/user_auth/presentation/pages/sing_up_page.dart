import 'package:flutter/material.dart';
import 'package:countertest/features/user_auth/presentation/pages/login_page.dart';
import 'package:countertest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:countertest/features/user_auth/presentation/repository/user_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  final UserAuthRepository userAuthRepository;

  const SignUpPage({super.key, required this.userAuthRepository});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Registro",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _usernameController,
                hintText: "Nombre de usuario",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Correo electrónico",
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
                  final String username = _usernameController.text;
                  final String email = _emailController.text;
                  final String password = _passwordController.text;

                  try {
                    await widget.userAuthRepository.registerUser(
                        email: email, password: password, username: username);

                    // Aquí puedes agregar la lógica para navegar a la pantalla de inicio de sesión
                  } on FirebaseAuthException catch (e) {
                    // Maneja los errores de autenticación de Firebase
                    setState(() {
                      _errorMessage = e.message;
                    });
                  }
                },
                child: const Text(
                  "Registrarse",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Ya tiene cuenta?"),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                  userAuthRepository: widget.userAuthRepository)),
                            (route) => false);
                      },
                      child: const Text(
                        "Entrar",
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
