import 'package:socket_io_client/socket_io_client.dart';

class Signaling {
  final Socket socket;
  final String roomId;

  Signaling(this.socket, this.roomId);

  void sendOffer(dynamic sdp) {
    socket.emit("webrtc:offer", {"roomId": roomId, "sdp": sdp});
  }

  void sendAnswer(dynamic sdp) {
    socket.emit("webrtc:answer", {"roomId": roomId, "sdp": sdp});
  }

  void sendCandidate(dynamic candidate) {
    socket.emit("webrtc:candidate", {"roomId": roomId, "candidate": candidate});
  }
}
