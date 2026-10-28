
import 'package:flutter/material.dart';

class CarregamentoPage extends StatefulWidget {
  final Widget destino;
  final String mensagem;

  const CarregamentoPage({
    super.key,
    required this.destino,
    this.mensagem = 'Realizando login...',
  });

  @override
  State<CarregamentoPage> createState() => _CarregamentoPageState();
}

class _CarregamentoPageState extends State<CarregamentoPage> {
  @override
  void initState() {
    super.initState();
    _iniciarCarregamento();
  }

  Future<void> _iniciarCarregamento() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => widget.destino,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pescaí'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: cores.primary,
            ),
            const SizedBox(height: 24),
            Text(
              widget.mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
