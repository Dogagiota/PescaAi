import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Carrinho {

  static const String chave = "carrinho";


  static Future<void> adicionar(
    String produto,
    double valor,
  ) async {

    final prefs = await SharedPreferences.getInstance();

    List itens = jsonDecode(
      prefs.getString(chave) ?? "[]"
    );


    itens.add({
      "produto": produto,
      "valor": valor,
    });


    await prefs.setString(
      chave,
      jsonEncode(itens),
    );

  }


  static Future<List> pegar() async {

    final prefs = await SharedPreferences.getInstance();

    return jsonDecode(
      prefs.getString(chave) ?? "[]"
    );

  }


  static Future<void> limpar() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(chave);

  }

}