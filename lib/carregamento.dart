import 'package:flutter/material.dart';
import 'main.dart';

class CarregamentoPage extends StatefulWidget {
  const CarregamentoPage({super.key});

  @override
  State<CarregamentoPage> createState() => _CarregamentoPageState();
}

class _CarregamentoPageState extends State<CarregamentoPage> {
  bool loginConcluido = false;

  @override
  void initState() {
    super.initState();

    // Espera 3 segundos mostrando o loading
   Future.delayed(const Duration(seconds: 1), () {
  if (!mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const MyApp(),
    ),
  );
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pescai"),
      ),
      body: Center(
        child: loginConcluido
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.scale(
                          scale: value,
                          child: Transform.rotate(
                            angle: (1 - value) * 0.5,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Login realizado com sucesso!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    "Realizando login...",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}