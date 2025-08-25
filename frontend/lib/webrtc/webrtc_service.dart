import 'package:frontend/webrtc/signaling.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:js_util';
import 'dart:js';

import 'interop.dart';

class WebRTCService {
  late RTCPeerConnection pc;
  late Signaling signaling;

  Future<void> init(String roomId, Socket socket) async {
    signaling = Signaling(socket, roomId);

    pc = RTCPeerConnection({
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"}
      ]
    });

    // Handle ICE
    pc.onicecandidate = allowInterop((event) {
      if (event.candidate != null) {
        signaling.sendCandidate(event.candidate);
      }
    });

    // Handle remote track
    pc.ontrack = allowInterop((event) {
      final remoteStream = event.streams[0];
      // TODO: bind to UI
    });
  }

  Future<void> startCall() async {
    final offer = await pc.createOffer();
    await pc.setLocalDescription(offer);
    signaling.sendOffer(offer);
  }

  Future<void> answerCall(dynamic offer) async {
    await pc.setRemoteDescription(offer);
    final answer = await pc.createAnswer();
    await pc.setLocalDescription(answer);
    signaling.sendAnswer(answer);
  }
}
