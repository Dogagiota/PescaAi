import 'package:flutter/material.dart';
import 'services/banco.dart';
import 'services/emailjs.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  String _tipo = 'cliente';
  bool _mostrarSenha = false;
  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    try {
      await Banco.instance.cadastrarUsuario(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text,
        tipo: _tipo,
      );

      final emailEnviado = await EmailJS.enviarBoasVindas(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            emailEnviado
                ? 'Conta criada! E-mail de boas-vindas enviado.'
                : 'Conta criada, mas não foi possível enviar o e-mail.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e, stackTrace) {
      debugPrint('ERRO AO CADASTRAR: $e');
      debugPrint('STACK TRACE: $stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          duration: const Duration(seconds: 10),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.phishing, size: 76, color: cores.primary),
                const SizedBox(height: 12),
                Text(
                  'Entre para o Pescaí!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 28),

                TextFormField(
                  controller: _nomeController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe seu nome.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    final email = valor?.trim() ?? '';
                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(email)) {
                      return 'Informe um e-mail válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _senhaController,
                  obscureText: !_mostrarSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _mostrarSenha ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _mostrarSenha = !_mostrarSenha;
                        });
                      },
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  'Tipo de conta',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                RadioListTile<String>(
                  title: const Text('Cliente'),
                  subtitle: const Text('Comprar equipamentos de pesca'),
                  value: 'cliente',
                  groupValue: _tipo,
                  onChanged: (valor) {
                    if (valor != null) {
                      setState(() => _tipo = valor);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Vendedor'),
                  subtitle: const Text('Gerenciar produtos da loja'),
                  value: 'vendedor',
                  groupValue: _tipo,
                  onChanged: (valor) {
                    if (valor != null) {
                      setState(() => _tipo = valor);
                    }
                  },
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _carregando ? null : _cadastrar,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: _carregando
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Criar conta'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
