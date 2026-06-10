import 'package:flutter/material.dart';

void
main() {
  runApp(
    const MyApp(),
  );
}

class MyApp
    extends
        StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget
  build(
    BuildContext
    context,
  ) {
    return MaterialApp(
      title: 'Pescai',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(
            255,
            39,
            187,
            26,
          ),
        ),
      ),
      home: const MyHomePage(
        title: 'Pescai',
      ),
    );
  }
}

class MyHomePage
    extends
        StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String
  title;

  @override
  State<
    MyHomePage
  >
  createState() =>
      _MyHomePageState();
}

class _MyHomePageState extends State < MyHomePage > with  TickerProviderStateMixin {
  late TabController
  aba;
  int carrin = 0;
  double valorcarrin = 0;
  void addcarrin(String produto, double valor) {
  setState(() {
    carrin++;
    valorcarrin += valor;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$produto adicionado ao carrinho'),
    ),
  );
}

  @override
  void
  initState() {
    super.initState();
    aba = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void
  dispose() {
    aba.dispose();
    super.dispose();
  }

  @override
  Widget
  build(
    BuildContext
    context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho: ($carrin) | R\$ ${valorcarrin.toStringAsFixed(2)}'),
      ),
      body: TabBarView(
        controller: aba,
        children: [
          Align(alignment: Alignment.topCenter,
            child: Column(mainAxisSize: MainAxisSize.min,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Vara de até 8kg"),
                          SizedBox(height: 8),
                          Text("Modelo Alpha"),
                          Text("Preço: R\$ 150"),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => addcarrin('Vara Modelo Alpha', 150),
                            child: Text('Adicionar ao carrinho'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Vara de até 20kg"),
                          SizedBox(height: 8),
                          Text("Modelo Titan"),
                          Text("Preço: R\$ 220"),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => addcarrin('Vara Modelo Titan', 220),
                            child: Text('Adicionar ao carrinho'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Vara de até 12kg"),
                          SizedBox(height: 8),
                          Text("Modelo Flex"),
                          Text("Preço: R\$ 180"),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => addcarrin('Vara Modelo Flex', 180),
                            child: Text('Adicionar ao carrinho'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Vara de até 25kg"),
                          SizedBox(height: 8),
                          Text("Modelo Carbon X"),
                          Text("Preço: R\$ 300"),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => addcarrin('Vara Modelo Carbon X', 300),
                            child: Text('Adicionar ao carrinho'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(alignment: Alignment.topCenter,
            child: Column(mainAxisSize: MainAxisSize.min,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Molinete de até 5kg de arrasto"),
                          SizedBox(height: 8),
                          Text("Modelo A"),
                          Text("Preço: R\$ 80"),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => addcarrin('Molinete Modelo A', 80),
                            child: Text('Adicionar ao carrinho'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Carretilha de até 5kg de arrasto"),
                          SizedBox(height: 8),
                          Text("Modelo B"),
                          Text("Preço: R\$ 100"),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => addcarrin('Carretilha Modelo B', 100),
                            child: Text('Adicionar ao carrinho'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Molinete de até 10kg de arrasto"),
                          SizedBox(height: 8),
                          Text("Modelo C"),
                          Text("Preço: R\$ 120"),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => addcarrin('Molinete Modelo C', 120),
                            child: Text('Adicionar ao carrinho'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Carretilha de até 10kg de arrasto"),
                          SizedBox(height: 8),
                          Text("Modelo D"),
                          Text("Preço: R\$ 130"),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => addcarrin('Carretilha Modelo D', 130),
                            child: Text('Adicionar ao carrinho'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(alignment: Alignment.topCenter,
            child: 
              Text("Outros"),
          ),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: aba,
        tabs: [
          Tab(
            icon: Image.asset('web/icons/vara.png',width: 48,height: 48,),
          ),
          Tab(
            icon: Image.asset('web/icons/molinete.png',width: 48,height: 48,),
          ),
          Tab(
            icon: Image.asset('web/icons/outros.png',width: 48,height: 48,),
          ),
        ],
      ),
    );
  }
}
