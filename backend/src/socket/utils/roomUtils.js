import { rooms, socketToRooms } from '../state.js';

export function ensureRoom(roomID, options = {}) {
  if (!rooms.has(roomID)) {
    rooms.set(roomID, {
      members: new Set(),
      capacity: options.capacity || 2,
      isRandom: options.isRandom || false
    });
  }
  return rooms.get(roomID);
}

export function addSocketToRoom(socket, roomID) {
  const room = ensureRoom(roomID);
  room.members.add(socket.id);
  socket.join(roomID);

  if (!socketToRooms.has(socket.id)) {
    socketToRooms.set(socket.id, new Set());
  }

  socketToRooms.get(socket.id).add(roomID);
}

export function removeSocketFromRoom(socket, roomID) {
  const room = rooms.get(roomID);
  if (!room) return;

  room.members.delete(socket.id);
  socket.leave(roomID);

  const sRooms = socketToRooms.get(socket.id);
  if (sRooms) {
    sRooms.delete(roomID);
    if (!sRooms.size) socketToRooms.delete(socket.id);
  }

  if (!room.members.size) rooms.delete(roomID);
}