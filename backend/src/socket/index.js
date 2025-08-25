import { socketMap, socketToRooms, removeSocketState } from './state.js';
import { handleRandomChat } from './handlers/random.js';
import { handleRoomEvents } from './handlers/rooms.js';
import { handleMessages } from './handlers/messages.js';
import registerWebRTCHandlers from './handlers/webrtc.js';

export default function registerSocketEvents(io) {
  io.on('connection', (socket) => {
    socketMap.set(socket.id, socket);
    console.log(`✅ Client connected: ${socket.id}`);

    handleRandomChat(socket, io);
    handleRoomEvents(socket, io);
    handleMessages(socket, io);
    registerWebRTCHandlers(io, socket);

    socket.on('disconnect', () => {
      removeSocketState(socket, io);
      console.log(`❌ Client disconnected: ${socket.id}`);
    });
  });
}