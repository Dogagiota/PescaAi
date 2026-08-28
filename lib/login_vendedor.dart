import 'package:flutter/material.dart';
import 'vendedor.dart';

class LoginVendedorPage extends StatelessWidget {
  const LoginVendedorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login do Vendedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(
                  Icons.email,
                  color: cores.primary,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: cores.primary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: cores.primary,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(
                  Icons.lock,
                  color: cores.primary,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: cores.primary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: cores.primary,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VendedorPage(),
                  ),
                );
              },
              child: const Text('Entrar como vendedor'),
            ),
          ],
        ),
      ),
    );
  }
}