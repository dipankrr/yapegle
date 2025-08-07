import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:frontend/utils/models/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:go_router/go_router.dart';

class SocketService extends ChangeNotifier {

  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late IO.Socket _socket;
  final List<Message> _messages = [];
  String roomId = '';
  //dynamic clients;

  List<Message> get messages => List.unmodifiable(_messages);

  bool _isConnecting = false;
  bool _isConnected = false;

  void connectToServer() {

    if(_isConnecting || _isConnected){
      print('already connected.........');
      return;
    }
    _isConnecting = true;

    _socket = IO.io(
      'http://192.168.0.102:3500', // use 10.0.2.2 for Android emulator
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket.connect();
    dynamic socketID = _socket.id;

    _socket.onConnect((_) {
      _isConnecting = false;
      _isConnected = true;
      print('✅ Connected to server -  $socketID');
    });

    _socket.on('chat-message', (data) {

      final msgData = Message.fromJson(data);
      _messages.add(msgData);
      notifyListeners(); // <-- notify listening widgets
    });

    _socket.on('create-room', (roomID) {
      roomId = roomID;
      notifyListeners();
      print(roomId);
    });

    _socket.on('room-joined', (roomID) {
      roomId = roomID;
      sendMessage('joined room', true);
      sendOwnMsg('you joined room $roomID', true);
      notifyListeners();
      print(roomId);
    });

    _socket.on('leave-room', (socketId) {

      sendMessage('$socketId left the room', true);
      sendOwnMsg('$socketId left the room', true);
      //roomId = '';
      print(socketId + ' left the room');
     // _messages.clear();
      notifyListeners();
    });

    _socket.on('room-full', (sId) {
      //if(_socket.id)
      sendOwnMsg('Room is full', true);
      print(sId + ' tried but room is full');
    });

    _socket.onDisconnect((_) {
      _isConnected = false;
      _isConnecting = false;
      print('❌ Disconnected from server');
    });
  }

  //


  void createRoom(bool data) {
     connectToServer();
    _socket.emit('create-room', data);

  }

  void joinRoom (String roomID){
    //connectToServer();
    _socket.emit('join-room', roomID);
    // _socket.on('room-clients', (totalRoomClient){
    //   if (totalRoomClient <2){
    //     roomId = roomID;
    //   }
    // });

  }

  void leaveRoom (){
    _socket.emit('leave-room', roomId);
    roomId = '';
    _messages.clear();
    notifyListeners();
  }

  void sendMessage(String message, bool isNoti) {

    final data = Message(
        room : roomId,
        msg : message,
        isMe : false,
        isNoti: isNoti
    );
    _socket.emit('chat-message', data.toJson());
  }

  void sendOwnMsg (String msg, bool isNoti){
    final data = Message(msg: msg, isMe: true, isNoti: isNoti);
    _messages.add(data);
    notifyListeners();
  }

  void disposeSocket() {
    _isConnected = false;
    _isConnecting = false;
    _socket.dispose();
  }
}
