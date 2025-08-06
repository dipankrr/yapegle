import 'package:flutter/material.dart';

import '../utils/models/message_model.dart';
//
// class ChatBubble extends StatelessWidget {
//   //final Message message;
//   final message;
//
//   const ChatBubble({Key? key, required this.message}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final isMe = message.isMe;
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.green[600] : Colors.grey[800],
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(12),
//             topRight: Radius.circular(12),
//             bottomLeft: Radius.circular(isMe ? 12 : 0),
//             bottomRight: Radius.circular(isMe ? 0 : 12),
//           ),
//         ),
//         child: Text(
//           message.text,
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final isNoti = message.isNoti;
    return Align(
      alignment: isNoti? Alignment.center : isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isNoti ? Colors.red : isMe ? Colors.green[800] : Colors.grey[800],

          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(isMe ? 12 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 12),
          ),
        ),
        child: Text(
          message.msg,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
