
import 'package:flutter/foundation.dart';
import 'package:emailjs/emailjs.dart' as emailjs;

class EmailJS {
  static const String serviceId = 'service_gavzp4p';
  static const String templateId = 'template_2uf52r8';
  static const String publicKey = 'sBCHt0zT9hBEWAhOX';

  static Future<bool> enviarBoasVindas({
    required String nome,
    required String email,
  }) async {
    try {
      debugPrint('EmailJS: iniciando envio para $email');

      final resposta = await emailjs.send(
        serviceId,
        templateId,
        {
          'nome': nome,
          'to_email': email,
        },
        const emailjs.Options(
          publicKey: publicKey,
        ),
      );

      debugPrint('EmailJS: status ${resposta.status}');
      debugPrint('EmailJS: resposta ${resposta.text}');

      return resposta.status == 200;
    } catch (e, stackTrace) {
      debugPrint('EmailJS: erro $e');
      debugPrint('$stackTrace');
      return false;
    }
  }
}
