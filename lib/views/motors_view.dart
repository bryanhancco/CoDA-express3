import 'package:flutter/material.dart';

class MotorsView extends StatefulWidget {
  const MotorsView({super.key});

  @override
  State<MotorsView> createState() => _MotorsViewState();
}

class _MotorsViewState extends State<MotorsView> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final userMessage = _ChatMessage(text: text, isUser: true);

    setState(() {
      _messages.add(userMessage);
      _controller.clear();
    });

    // Guardar mensaje del usuario en la base de datos local
    await saveMessageToDatabase(userMessage);

    // Obtener la respuesta del bot desde una API HTTPS
    final botText = await getBotResponseFromApi(text);
    final botMessage = _ChatMessage(text: botText, isUser: false);

    // Agregar y guardar la respuesta del bot
    setState(() {
      _messages.add(botMessage);
    });

    await saveMessageToDatabase(botMessage);
  }

  Future<void> saveMessageToDatabase(_ChatMessage message) async {
    // Aquí usas sqflite u otra librería para guardar el mensaje
    //await DatabaseHelper.instance.insertMessage(message);
    return;
  }

  Future<String> getBotResponseFromApi(String userMessage) async {
    /*final uri = Uri.parse("https://tu-api.com/responder");
    final response = await http.post(
      uri,
      body: {'message': userMessage},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['respuesta'] ?? "Sin respuesta.";
    } else {
      return "Error del bot.";
    }*/
    return "Respuesta";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(50.0),
          child: Text(
            'Chat de Motores',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              return Align(
                alignment:
                msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(maxWidth: 250),
                  decoration: BoxDecoration(
                    color: msg.isUser
                        ? Colors.blueAccent.shade100
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(msg.text),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Escribe un mensaje...",
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  _ChatMessage({required this.text, required this.isUser});
}