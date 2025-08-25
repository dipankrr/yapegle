import { nanoid } from 'nanoid';
import { ensureRoom, addSocketToRoom, removeSocketFromRoom } from '../utils/roomUtils.js';
import { isNonEmptyString } from '../utils/validators.js';
import { ONE_TO_ONE_CAPACITY } from '../config.js';
import { rooms } from '../state.js';

export function handleRoomEvents(socket, io) {
  socket.on('create-room', () => {
    const roomID = `c-${nanoid(10)}`;
    ensureRoom(roomID, { capacity: ONE_TO_ONE_CAPACITY });
    socket.emit('create-room', { roomID });
  });

  socket.on('join-room', (roomID) => {
    if (!isNonEmptyString(roomID)) return socket.emit('error', { code: 'INVALID_ROOM' });

    const room = rooms.get(roomID);
    if (!room) return socket.emit('room-not-found', { roomID });

    if (room.members.has(socket.id)) return socket.emit('room-joined', { roomID });

    if (room.members.size >= room.capacity) return socket.emit('room-full', { roomID });

    addSocketToRoom(socket, roomID);
    socket.emit('room-joined', { roomID });
    socket.to(roomID).emit('peer-joined', { roomID, peerId: socket.id });
  });

  socket.on('leave-room', (roomID) => {
    removeSocketFromRoom(socket, roomID);
    socket.to(roomID).emit('peer-left', { roomID, peerId: socket.id });
  });
}