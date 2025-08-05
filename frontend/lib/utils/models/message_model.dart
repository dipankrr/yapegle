class Message {
  final String? room;
  final String msg;
  final bool isMe;

  Message({
     this.room,
    required this.msg,
    required this.isMe,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      room: json['room'],
      msg: json['msg'],
      isMe: json['isMe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room': room,
      'msg': msg,
      'isMe': isMe,
    };
  }
}
