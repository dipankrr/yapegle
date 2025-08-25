import { isNonEmptyString } from '../utils/validators.js';
import { rooms, messageBuckets } from '../state.js';
import { MESSAGE_RATE_LIMIT } from '../config.js';

function rateLimit(socketId) {
  const now = Date.now();
  const state = messageBuckets.get(socketId) || { tokens: MESSAGE_RATE_LIMIT.capacity, lastRefillMs: now };
  const elapsedSec = (now - state.lastRefillMs) / 1000;
  const refill = elapsedSec * MESSAGE_RATE_LIMIT.refillPerSec;

  state.tokens = Math.min(MESSAGE_RATE_LIMIT.burst, state.tokens + refill);
  state.lastRefillMs = now;

  if (state.tokens >= 1) {
    state.tokens -= 1;
    messageBuckets.set(socketId, state);
    return true;
  }

  messageBuckets.set(socketId, state);
  return false;
}

export function handleMessages(socket, io) {
  // socket.on('chat-message', ({ room, msg }) => {
  //   if (!isNonEmptyString(room) || !isNonEmptyString(msg)) return;

  //   const roomInfo = rooms.get(room);
  //   if (!roomInfo || !roomInfo.members.has(socket.id)) return;

  //   if (!rateLimit(socket.id)) {
  //     return socket.emit('error', { code: 'RATE_LIMITED', message: 'Too fast!' });
  //   }

  //   socket.to(room).emit('chat-message', {
  //     room,
  //     from: socket.id,
  //     msg,
  //     ts: Date.now()
  //   });
  // });

  /// 

  socket.on('chat-message', (data) => {

    const {room, msg} = data;

    if (!isNonEmptyString(room) || !isNonEmptyString(msg)) return;

    const roomInfo = rooms.get(room);
    if (!roomInfo || !roomInfo.members.has(socket.id)) return;

    if (!rateLimit(socket.id)) {
      return socket.emit('error', { code: 'RATE_LIMITED', message: 'Too fast!' });
    }

    socket.to(room).emit('chat-message', {
      data,
      room,
      from: socket.id,
      msg,
      ts: Date.now()
    });
  });
}