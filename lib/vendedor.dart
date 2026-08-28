import 'package:flutter/material.dart';
import 'services/banco.dart';

class VendedorPage extends StatefulWidget {
  const VendedorPage({super.key});

  @override
  State<VendedorPage> createState() => _VendedorPageState();
}

class _VendedorPageState extends State<VendedorPage> {
  List<Map<String, dynamic>> produtos = [];

  @override
  void initState() {
    super.initState();

    carregarProdutos();
  }

  // =========================
  // READ
  // =========================

  Future<void> carregarProdutos() async {
    final dados = await Banco.instance.listarProdutos();

    setState(() {
      produtos = dados;
    });
  }

  // =========================
  // CREATE
  // =========================

  void adicionarProduto() {
    final nomeController = TextEditingController();
    final descricaoController = TextEditingController();
    final precoController = TextEditingController();

    String categoria = "Varas";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Adicionar produto"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: "Nome",
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      initialValue: categoria,

                      decoration: const InputDecoration(
                        labelText: "Categoria",
                      ),

                      items: const [
                        DropdownMenuItem(
                          value: "Varas",
                          child: Text("Varas"),
                        ),

                        DropdownMenuItem(
                          value: "Molinetes/Carretilhas",
                          child: Text("Molinetes/Carretilhas"),
                        ),

                        DropdownMenuItem(
                          value: "Outros",
                          child: Text("Outros"),
                        ),
                      ],

                      onChanged: (valor) {
                        setStateDialog(() {
                          categoria = valor!;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: descricaoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Descrição",
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: precoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Preço",
                        prefixText: "R\$ ",
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await Banco.instance.adicionarProduto(
                      nomeController.text,
                      categoria,
                      descricaoController.text,
                      double.tryParse(precoController.text) ?? 0,
                    );
                    if (!context.mounted) return;
                  
                    Navigator.pop(context);

                    carregarProdutos();
                  },
                  child: const Text("Adicionar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // =========================
  // UPDATE
  // =========================

  void editarProduto(int index) {
    final produto = produtos[index];

    final nomeController = TextEditingController(
      text: produto["nome"],
    );

    final descricaoController = TextEditingController(
      text: produto["descricao"],
    );

    final precoController = TextEditingController(
      text: produto["preco"].toString(),
    );

    String categoria = produto["categoria"];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Editar produto"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: "Nome",
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      initialValue: categoria,

                      decoration: const InputDecoration(
                        labelText: "Categoria",
                      ),

                      items: const [
                        DropdownMenuItem(
                          value: "Varas",
                          child: Text("Varas"),
                        ),

                        DropdownMenuItem(
                          value: "Molinetes/Carretilhas",
                          child: Text("Molinetes/Carretilhas"),
                        ),

                        DropdownMenuItem(
                          value: "Outros",
                          child: Text("Outros"),
                        ),
                      ],

                      onChanged: (valor) {
                        setStateDialog(() {
                          categoria = valor!;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: descricaoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Descrição",
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: precoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Preço",
                        prefixText: "R\$ ",
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await Banco.instance.editarProduto(
                      produto["id"],
                      nomeController.text,
                      categoria,
                      descricaoController.text,
                      double.tryParse(precoController.text) ?? 0,
                    );
                    if (!context.mounted) return;
                    Navigator.pop(context);

                    carregarProdutos();
                  },
                  child: const Text("Salvar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // =========================
  // DELETE
  // =========================

  Future<void> excluirProduto(int index) async {
    final produto = produtos[index];

    await Banco.instance.excluirProduto(
      produto["id"],
    );

    carregarProdutos();
  }

  // =========================
  // TELA
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Área do Vendedor"),
      ),

      body: produtos.isEmpty
          ? const Center(
              child: Text(
                "Nenhum produto cadastrado.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: produtos.length,

              itemBuilder: (context, index) {
                final produto = produtos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  child: ListTile(
                    title: Text(
                      produto["nome"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      "${produto["categoria"]}\n"
                      "${produto["descricao"]}\n"
                      "R\$ ${produto["preco"].toStringAsFixed(2)}",
                    ),

                    isThreeLine: true,

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),

                          onPressed: () {
                            editarProduto(index);
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete),

                          onPressed: () {
                            excluirProduto(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: adicionarProduto,

        child: const Icon(Icons.add),
      ),
    );
  }
}