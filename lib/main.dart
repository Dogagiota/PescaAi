import 'package:flutter/material.dart';
import 'services/carrinho.dart';
import 'services/banco.dart';
import 'carrinho_page.dart';
import 'historico_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pescai',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        secondaryHeaderColor: Colors.amber,
      ),
      home: const HomePage(title: 'Pescai'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController aba;

  int carrin = 0;
  double valorcarrin = 0;

  List<Map<String, dynamic>> produtos = [];
  Future<void> carregarCarrinho() async {
    final itens = await Carrinho.pegar();

    setState(() {
      carrin = itens.length;

      valorcarrin = itens.fold(0.0, (total, item) => total + item["valor"]);
    });
  }

  void addcarrin(String produto, double valor) async {
    await Carrinho.adicionar(produto, valor);
    setState(() {
      carrin++;
      valorcarrin += valor;
    });
    
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$produto adicionado ao carrinho')));
  }

  Future<void> carregarProdutos() async {
    final dados = await Banco.instance.listarProdutos();

    setState(() {
      produtos = dados;
    });
  }

  Widget mostrarProdutos(String categoria) {
    final produtosCategoria = produtos
        .where((produto) => produto["categoria"] == categoria)
        .toList();

    if (produtosCategoria.isEmpty) {
      return const Center(
        child: Text(
          "Nenhum produto cadastrado.",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),

      child: Column(
        children: [
          for (int i = 0; i < produtosCategoria.length; i += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(produtosCategoria[i]["nome"]),

                        const SizedBox(height: 8),

                        Text(produtosCategoria[i]["descricao"]),

                        Text(
                          "Preço: R\$ "
                          "${produtosCategoria[i]["preco"].toStringAsFixed(2)}",
                        ),

                        const SizedBox(height: 8),

                        ElevatedButton(
                          onPressed: () {
                            addcarrin(
                              produtosCategoria[i]["nome"],
                              produtosCategoria[i]["preco"],
                            );
                          },

                          child: const Text("Adicionar ao carrinho"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: i + 1 < produtosCategoria.length
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(produtosCategoria[i + 1]["nome"]),

                              const SizedBox(height: 8),

                              Text(produtosCategoria[i + 1]["descricao"]),

                              Text(
                                "Preço: R\$ "
                                "${produtosCategoria[i + 1]["preco"].toStringAsFixed(2)}",
                              ),

                              const SizedBox(height: 8),

                              ElevatedButton(
                                onPressed: () {
                                  addcarrin(
                                    produtosCategoria[i + 1]["nome"],
                                    produtosCategoria[i + 1]["preco"],
                                  );
                                },

                                child: const Text("Adicionar ao carrinho"),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();

    aba = TabController(length: 3, vsync: this);

    carregarCarrinho();
    carregarProdutos();
  }

  @override
  void dispose() {
    aba.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carrinho: ($carrin) | '
          'R\$ ${valorcarrin.toStringAsFixed(2)}',
        ),

        actions: [
          // HISTÓRICO
          IconButton(
            icon: const Icon(Icons.history),

            onPressed: () {
              Navigator.push(
                context,

                MaterialPageRoute(builder: (context) => const HistoricoPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CarrinhoPage()),
              );

              carregarCarrinho();
            },
          ),
        ],
      ),

      // =========================
      // CATEGORIAS
      // =========================
      body: TabBarView(
        controller: aba,

        children: [
          mostrarProdutos("Varas"),
          mostrarProdutos("Molinetes/Carretilhas"),
          mostrarProdutos("Outros"),
        ],
      ),

      bottomNavigationBar: TabBar(
        controller: aba,

        tabs: [
          Tab(icon: Image.asset('web/icons/vara.png', width: 48, height: 48)),

          Tab(
            icon: Image.asset('web/icons/molinete.png', width: 48, height: 48),
          ),

          Tab(icon: Image.asset('web/icons/outros.png', width: 48, height: 48)),
        ],
      ),
    );
  }
}
