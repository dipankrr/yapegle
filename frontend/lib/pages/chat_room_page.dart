import 'package:flutter/material.dart';
import 'package:frontend/components/chat_bubble.dart';
import 'package:frontend/services/socket_service.dart';
import 'package:frontend/utils/models/message_model.dart';
import 'package:provider/provider.dart';

import '../components/message_input.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<SocketService>().messages;


    return Scaffold(
      appBar: AppBar(
        title: Text("yapegle", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                height: 150, width: 300,
                color: Colors.grey,
              ),Container(
                height: 150, width: 300,
                color: Colors.grey,
              ),
            ],
          ),

          Expanded(
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) {
                    final message = messages[messages.length - index - 1];

                    return ChatBubble(message: message);
                  },
                );
              },
            ),
          ),
          const MessageInput(),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}

