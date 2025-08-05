import 'package:frontend/pages/chat_room_page.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/services/socket_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final GoRouter appRoute = GoRouter(
    initialLocation: '/',
    routes: [

      GoRoute(
          path: '/',
          builder: (context, state) => const HomePage()
      ),

      GoRoute(
          path: '/room/:roomId',
          builder: (context, state) {
            final String? pathRoomId = state.pathParameters['roomId'];
            // TODO: when lands this url make user join and connect to server

            final socketService = context.watch<SocketService>();

            socketService.connectToServer();
            socketService.joinRoom(pathRoomId!);
            return const ChatRoomPage();
        }
      ),


    ]
);
