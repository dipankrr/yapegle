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
      'http://localhost:3500', // use 10.0.2.2 for Android emulator
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

    _socket.on('join-room', (roomID) {
      roomId = roomID;
      notifyListeners();
      print(roomId);
    });

    _socket.on('room-full', (roomID) {
      print('room is full');
    });


    _socket.onDisconnect((_) {
      _isConnected = false;
      _isConnecting = false;
      print('❌ Disconnected from server');
    });
  }

  //

  void createRoom(bool data) {
    // connectToServer();
    _socket.emit('create-room', data);

    // _socket.on('create-room', (roomID){
    //   roomId = roomID;
    //   print(roomID + '***' + roomId);
    // });
    notifyListeners();
  }

  void joinRoom (String roomID){
    //connectToServer();
    roomId = roomID;
    _socket.emit('join-room', roomID);

  }

  void sendMessage(String message) {

    final data = Message(
        room : roomId,
        msg : message,
        isMe : false
    );
    _socket.emit('chat-message', data.toJson());
  }

  void sendOwnMsg (String msg){
    final data = Message(msg: msg, isMe: true);
    _messages.add(data);
    notifyListeners();
  }

  void disposeSocket() {
    _isConnected = false;
    _isConnecting = false;
    _socket.dispose();
  }
}
