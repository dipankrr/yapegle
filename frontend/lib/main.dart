import 'package:flutter/material.dart';
import 'package:frontend/routes/app_router.dart';
import 'package:frontend/services/socket_service.dart';
import 'package:frontend/utils/theme/themes.dart';
import 'package:provider/provider.dart';
//import 'package:frontend/pages/h_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SocketService>( create: (_) => SocketService() ),
        
        // ChangeNotifierProvider(create: (_) => SomeOtherService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRoute,
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      //home: const HomePage(),
    );
  }
}



//////////////////////////



// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// void main() => runApp(ChatApp());

// class ChatApp extends StatefulWidget {
//   @override
//   State<ChatApp> createState() => _ChatAppState();
// }

// class _ChatAppState extends State<ChatApp> {
//   late IO.Socket socket;
//   List<String> messages = [];
//   final TextEditingController controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     socket = IO.io('http://10.0.2.2:3000',  // Use 10.0.2.2 for Android emulator
//       IO.OptionBuilder()
//         .setTransports(['websocket'])
//         .disableAutoConnect()
//         .build());

//     socket.connect();

//     socket.onConnect((_) {
//       print('✅ Connected to server');
//     });

//     socket.on('chat-message', (data) {
//       setState(() {
//         messages.add(data);
//       });
//     });

//     socket.onDisconnect((_) => print('❌ Disconnected from server'));
//   }

//   void sendMessage() {
//     final text = controller.text.trim();
//     if (text.isNotEmpty) {
//       socket.emit('chat-message', text);
//       controller.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Flutter Chat")),
//         body: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 children: messages.map((msg) => ListTile(title: Text(msg))).toList(),
//               ),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(controller: controller),
//                 ),
//                 IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
