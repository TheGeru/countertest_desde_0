import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurar contraseña',
          style: TextStyle(color: Color.fromARGB(255, 10, 0, 0)),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ingresa tu correo electrónico para restablecer la contraseña',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ingresa tu correo electrónico',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
              height: 10), // Agrega espacio entre el campo de texto y el botón
          const BotonEnviar(), // Agrega el widget BotonEnviar
        ],
      ),
    );
  }
}

class BotonEnviar extends StatelessWidget {
  const BotonEnviar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color(0xff142047),
          ),
        ),
        child: const Text(
          'Enviar Correo',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
