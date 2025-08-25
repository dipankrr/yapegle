export const rooms = new Map(); // roomID => { members, capacity, etc }
export const socketMap = new Map(); // socketID => socket
export const socketToRooms = new Map(); // socketID => Set<roomID>
export const waitingQueue = [];
export const QUEUE_SET = new Set();
export const messageBuckets = new Map(); // socketID => rate state

export function removeSocketState(socket, io) {
  const roomIDs = socketToRooms.get(socket.id) || [];
  roomIDs.forEach(roomID => {
    const room = rooms.get(roomID);
    if (room) {
      room.members.delete(socket.id);
      if (room.members.size === 0) rooms.delete(roomID);
      else io.to(roomID).emit('peer-left', { roomID, peerId: socket.id });
    }
  });

  socketMap.delete(socket.id);
  socketToRooms.delete(socket.id);
  messageBuckets.delete(socket.id);
  QUEUE_SET.delete(socket.id);
}