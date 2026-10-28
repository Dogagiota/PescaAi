
import 'package:flutter/material.dart';
import 'services/banco.dart';
import 'cadastro.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _mostrarSenha = false;
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      _mostrarMensagem('Preencha o e-mail e a senha.');
      return;
    }

    setState(() => _carregando = true);

    try {
      final usuario = await Banco.instance.autenticarUsuario(
        email: email,
        senha: senha,
        tipo: 'cliente',
      );

      if (!mounted) return;

      if (usuario == null) {
        _mostrarMensagem('E-mail ou senha incorretos para uma conta de cliente.');
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(title: 'Pescai'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarMensagem('Erro ao realizar login.');
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  void _abrirCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CadastroPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.phishing,
                    size: 90,
                    color: cores.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pescaí',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Entre na sua conta para continuar pescando boas ofertas.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _senhaController,
                    obscureText: !_mostrarSenha,
                    onSubmitted: (_) => _entrar(),
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        tooltip: _mostrarSenha
                            ? 'Ocultar senha'
                            : 'Mostrar senha',
                        icon: Icon(
                          _mostrarSenha
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _mostrarSenha = !_mostrarSenha;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _carregando ? null : _entrar,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: _carregando
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Entrar'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  OutlinedButton(
                    onPressed: _abrirCadastro,
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Criar conta'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login-vendedor');
                    },
                    child: const Text('Entrar como vendedor'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
