import 'package:flutter/material.dart';
import 'login.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlue,
          brightness: Brightness.dark,
        ),
      ),
      home: const Splashscreen(),
    ),
  );
}
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool loginConcluido = false;

  @override
  void initState() {
    super.initState();
    // Espera 5 segundos mostrando o loading
   Future.delayed(const Duration(seconds: 5), () {
  if (!mounted) return;
  
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const LoginPage(),
    ),
  );
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF022346),
      appBar: AppBar(
        title: const Text("Pescai"),
      ),
      body: Center(
        child: Image.asset('images/buh.jpg', width: 1500, height: 1500),
      ),
    );
  }
}