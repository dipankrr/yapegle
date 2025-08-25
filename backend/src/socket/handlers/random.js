import { nanoid } from 'nanoid';
import { waitingQueue, QUEUE_SET, socketMap } from '../state.js';
import { ensureRoom, addSocketToRoom } from '../utils/roomUtils.js';
import { ONE_TO_ONE_CAPACITY } from '../config.js';
import logger from '../utils/logger.js';

export function handleRandomChat(socket, io) {
  socket.on('chat-random', () => {

    logger.info("chat-random called 11111");
    
    if (QUEUE_SET.has(socket.id)) {
      socket.emit('random-status', { status: 'waiting' });
      return;
    }

    logger.debug(QUEUE_SET);

    const partnerId = waitingQueue.find(id => id !== socket.id && socketMap.has(id));
    if (partnerId) {
      QUEUE_SET.delete(partnerId);
      waitingQueue.splice(waitingQueue.indexOf(partnerId), 1);
      const partner = socketMap.get(partnerId);

      const roomID = `r-${nanoid(10)}`;

      logger.debug(`room id: ${roomID}`);

      ensureRoom(roomID, { capacity: ONE_TO_ONE_CAPACITY, isRandom: true });
      //addSocketToRoom(socket, roomID);
      addSocketToRoom(partner, roomID);

      socket.emit('random-paired', { roomID, peerId: partner.id });
      partner.emit('random-paired', { roomID, peerId: socket.id });

      io.to(roomID).emit('room-clients', { roomID, count: 2 });

    } else {
      waitingQueue.push(socket.id);
      QUEUE_SET.add(socket.id);

      logger.info(`waiting for partner '2'`);

      socket.emit('random-status', { status: 'waiting' });
    }
  });

  socket.on('random-cancel', () => {
    QUEUE_SET.delete(socket.id);
    socket.emit('random-status', { status: 'canceled' });
  });
}
