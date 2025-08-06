import 'package:flutter/material.dart';
import 'package:frontend/components/chat_bubble.dart';
import 'package:frontend/components/custom_button.dart';
import 'package:frontend/services/socket_service.dart';
import 'package:frontend/utils/models/message_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../components/message_input.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<SocketService>().messages;


    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("yapegle", style: TextStyle(color: Colors.white),),
            CustomButton(
                text: 'Leave',
                backgroundColor: Colors.red,
                height: 40, width: 80,
                textSize: 15,
                iconAfterText: true,
                icon: Icons.logout,
                onTap: (){
                  Provider.of<SocketService>(context, listen: false).leaveRoom();

                  GoRouter.of(context).replace('/');

                }
            )
          ],
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 150, width: double.infinity,
                  child: Card(
                    color: Colors.white24,
                    child: Column(
                      children: [
                        Icon(Icons.videocam_outlined, size: 80,),
                        Text('coming soon...')
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 150, width: double.infinity,
                  child: Card(
                    color: Colors.white24,
                    child: Column(
                      children: [
                        Icon(Icons.videocam_outlined, size: 80,),
                        Text('coming soon...')
                      ],
                    ),
                  ),
                ),
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

