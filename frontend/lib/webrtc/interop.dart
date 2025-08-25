import 'dart:js_interop';
import 'dart:js_util';

@JS()
class MediaStream {
  external List<dynamic> getTracks();
}
@JS()
class RTCDataChannel {
  external void send(String message);

  external set onmessage(Function(dynamic event));
  external set onopen(Function());
  external set onclose(Function());
}


@JS('RTCPeerConnection')
class RTCPeerConnection {
  external factory RTCPeerConnection([dynamic config]);

  external void addStream(MediaStream stream);
  external RTCDataChannel createDataChannel(String label);
  external dynamic createOffer();
  external dynamic createAnswer();
  external dynamic setLocalDescription(dynamic description);
  external dynamic setRemoteDescription(dynamic description);
  external dynamic addIceCandidate(dynamic candidate);

  external set onicecandidate(Function(dynamic event));
  external set ontrack(Function(dynamic event));
  external set ondatachannel(Function(dynamic event));
}

@JS('navigator.mediaDevices.getUserMedia')
external dynamic _getUserMedia(dynamic constraints);

Future<MediaStream> getUserMedia(Map<String, dynamic> constraints) {
  return promiseToFuture(_getUserMedia(constraints));
}
