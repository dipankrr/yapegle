class Message {
  final String? room;
  final String msg;
  final bool isMe;
  final bool isNoti;

  Message({
     this.room,
    required this.msg,
    required this.isMe,
    this.isNoti = false
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      room: json['room'],
      msg: json['msg'],
      isMe: json['isMe'],
      isNoti: json['isNoti']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room': room,
      'msg': msg,
      'isMe': isMe,
      'isNoti': isNoti
    };
  }
}
