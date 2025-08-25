// /src/socket/handlers/webrtc.js
import { isNonEmptyString, isJson } from '../utils/validators.js';
import { getRoomPeers, getPeerPartner } from '../utils/roomUtils.js';
//import { limiterEmit, limiterPerSocket } from '../utils/rateLimiter.js';

export default function registerWebRTCHandlers(io, socket) {
  // Simple per-socket signaling rate limit (bursty but bounded)
//   const checkLimit = (event) => {
//     if (!limiterPerSocket(socket.id).tryRemoveTokens(1)) {
//       return false;
//     }
//     if (!limiterEmit().tryRemoveTokens(1)) {
//       return false;
//     }
//     return true;
//   };


  // Helper: relay to partner in same room
  const relay = (roomId, event, payload) => {
    const partnerId = getPeerPartner(roomId, socket.id);
    if (!partnerId) return;
    io.to(partnerId).emit(event, payload);
  };


  // Client says: “I’m ready for WebRTC” (after you’ve matched two peers)
  socket.on('webrtc:ready', ({ roomId }) => {
    if (!isNonEmptyString(roomId)) return;
    const peers = getRoomPeers(roomId);
    if (!peers.has(socket.id)) return;       // must be in room
    relay(roomId, 'webrtc:peer-ready', { peerId: socket.id });
  });


  // SDP offer
  socket.on('webrtc:offer', ({ roomId, sdp }) => {
    //if (!checkLimit('offer')) return;
    if (!isNonEmptyString(roomId) || !isJson(sdp)) return;
    const peers = getRoomPeers(roomId);
    if (!peers.has(socket.id) || peers.size !== 2) return;
    relay(roomId, 'webrtc:offer', { from: socket.id, sdp });
  });


  // SDP answer
  socket.on('webrtc:answer', ({ roomId, sdp }) => {
    //if (!checkLimit('answer')) return;
    if (!isNonEmptyString(roomId) || !isJson(sdp)) return;
    const peers = getRoomPeers(roomId);
    if (!peers.has(socket.id) || peers.size !== 2) return;
    relay(roomId, 'webrtc:answer', { from: socket.id, sdp });
  });


  // ICE candidates (multiple, frequent)
  socket.on('webrtc:candidate', ({ roomId, candidate }) => {
    //if (!checkLimit('candidate')) return;
    if (!isNonEmptyString(roomId) || !isJson(candidate)) return;
    const peers = getRoomPeers(roomId);
    if (!peers.has(socket.id) || peers.size !== 2) return;
    relay(roomId, 'webrtc:candidate', { from: socket.id, candidate });
  });


  // Optional renegotiation events
  socket.on('webrtc:renegotiate', ({ roomId }) => {
    //if (!checkLimit('renegotiate')) return;
    if (!isNonEmptyString(roomId)) return;
    relay(roomId, 'webrtc:renegotiate', { from: socket.id });
  });


  // If a peer disconnects, tell the partner to tear down
  socket.on('disconnect', () => {
    // Your rooms.js should already emit a room-level event; this is a safety net
    socket.rooms.forEach((roomId) => {
      relay(roomId, 'webrtc:peer-left', { peerId: socket.id });
    });
  });
}
