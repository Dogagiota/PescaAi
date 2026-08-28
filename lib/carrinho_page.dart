import 'package:flutter/material.dart';
import 'services/carrinho.dart';
import 'services/banco.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  List itens = [];

  double total = 0;

  @override
  void initState() {
    super.initState();

    carregar();
  }

  Future<void> carregar() async {
    final dados = await Carrinho.pegar();

    setState(() {
      itens = dados;

      total = itens.fold(0.0, (soma, item) => soma + item["valor"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meu Carrinho")),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: itens.length,

              itemBuilder: (context, index) {
                final item = itens[index];

                return Card(
                  child: ListTile(
                    title: Text(item["produto"]),

                    trailing: Text("R\$ ${item["valor"].toStringAsFixed(2)}"),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                Text(
                  "Total: R\$ ${total.toStringAsFixed(2)}",

                  style: const TextStyle(
                    fontSize: 22,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await Banco.instance.adicionarCompra(itens, total);
                        await Carrinho.limpar();
                        if (!context.mounted) return;

                        setState(() {
                          itens.clear();

                          total = 0;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Compra realizada!")),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Erro: $e")));
                      }
                    },
                    child: const Text("Comprar"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
