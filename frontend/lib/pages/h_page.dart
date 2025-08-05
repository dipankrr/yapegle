import 'package:flutter/material.dart';
import 'package:frontend/form.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IO.Socket socket;
  List<String> messages = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    socket = IO.io(
        'http://localhost:3500', // Use 10.0.2.2 for Android emulator
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to server');
    });

    socket.on('chat-message', (data) {
      setState(() {
        messages.add(data);
      });
    });

    socket.onDisconnect((_) => print('❌ Disconnected from server'));
  }

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      socket.emit('chat-message', text);
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
            Expanded(
              child: ListView(
                children: messages.map((msg) => ListTile(title: Text(msg))).toList(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(cntrl: controller),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
              ],
            )
          ],
      ),
    );
  }
}
