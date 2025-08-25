
const express = require('express');
const { nanoid } = require('nanoid');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*', // Allow all for now (for Flutter debugging)
  },
});

 
 let rooms = []


// websocket

io.on('connection', (socket) => {

  console.log('✅ Client connected:', socket.id);

  // chat with random

  socket.on('chat-random', () => {

    let waitingQueue = [];

    if (waitingQueue.length) {

      try {
        const matchedUser = waitingQueue.shift();
        
        const roomID = `r-${matchedUser.id}-${socket.id}`
  
        matchedUser.join(roomID)
        socket.join(roomID)
        
      } catch (error) {
        
      }
    } else{
      waitingQueue = socket
    }
    
  })

  // custom room

  socket.on('create-room', (data) => {

    if (data==true) {

      const roomID = nanoid()

      rooms.push(roomID)

      console.log(roomID)
      console.log(rooms)

      socket.emit('create-room', roomID);
    }
   
    //socket.join(roomID);

  })

  //helper funcs

  function isValidRoom(roomID){
    return rooms.includes(roomID)
  }

  function isClientAlreadyInRoom(socketID, roomID) {
      const totalRoomClient = io.sockets.adapter.rooms.get(roomID)?.size ?? 0;
      const clients = io.sockets.adapter.rooms.get(roomID);
      clients?.has(socketID)
  }

  socket.on('join-room', (roomID) => {

    if (!isValidRoom(roomID)) { socket.emit('room-not-found', roomID) }
    

    if (rooms.includes(roomID)) {
      const totalRoomClient = io.sockets.adapter.rooms.get(roomID)?.size ?? 0;
      const clients = io.sockets.adapter.rooms.get(roomID);

      //socket.emit('room-clients', totalRoomClient)

      if (clients?.has(socket.id)) {
        console.log('🤡🤡 you are already in the room ', socket.id)
        return;
      }

      if (totalRoomClient<2) {
        
        socket.join(roomID);
        socket.emit('room-joined', roomID)
        console.log(`➡️ ${socket.id} joined in room ${roomID}`);

      } else {
        socket.emit('room-full', socket.id )
        console.log(socket.id , " 👈 this nigga tried to join full room ", roomID);
        
        console.log('room is full - ', totalRoomClient, clients);
        
      }
       
       
    } else{
      console.log('room does not exist!!!!!');
    }
   
  })

  socket.on('leave-room', (roomID) =>{

    socket.leave(roomID)
    console.log('⬅️ ', socket.id , ' left room ', roomID);
    
    socket.to(roomID).emit('leave-room', socket.id)

  })


  socket.on('chat-message', (data) => {

    const {room, msg} = data;

    console.log('💬 Message received:', msg, room);

    socket.to(room).emit('chat-message', data);
    //io.to(room).emit('chat-message', data); // mmmmmmmmmm
  });

  socket.on('disconnect', () => {
    console.log('❌ Client disconnected:', socket.id);
  });

});


// routes

app.get('/', (req, res) => {
  res.send('Server is running');
});



// server listen

server.listen(3500, '192.168.0.103', () => {
  console.log('🚀 Server listening on http://localhost:3500');
});