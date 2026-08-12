import 'package:flutter/material.dart';
import 'services/banco.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  List<Map<String, dynamic>> compras = [];

  @override
  void initState() {
    super.initState();

    carregarCompras();
  }

  Future<void> carregarCompras() async {
    final dados = await Banco.instance.listarCompras();

    setState(() {
      compras = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Compras"),
      ),

      body: compras.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma compra realizada.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: compras.length,

              itemBuilder: (context, index) {
                final compra = compras[index];

                final itens = compra["itens"] as List<Map<String, dynamic>>;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Compra ${compras.length - index}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          compra["data"],
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 15),

                        ...itens.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),

                            child: Row(
                              children: [
                                const Icon(
                                  Icons.shopping_bag,
                                  size: 20,
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: Text(
                                    item["produto"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                Text(
                                  "R\$ ${item["valor"].toStringAsFixed(2)}",
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Divider(),

                        Align(
                          alignment: Alignment.centerRight,

                          child: Text(
                            "Total: R\$ ${compra["valor"].toStringAsFixed(2)}",

                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}