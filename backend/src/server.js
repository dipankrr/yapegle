import http from 'http';
import express from 'express';
import { Server } from 'socket.io';
import dotenv from 'dotenv';
import { setupMiddleware } from './middlewares/setupMiddleware.js';
import healthRoutes from './routes/health.js';
import registerSocketEvents from './socket/index.js';

dotenv.config();

const app = express();
const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: process.env.FRONTEND_ORIGIN?.split(',').map(s => s.trim()) || '*',
    credentials: true
  },
  pingTimeout: 20000,
  pingInterval: 25000
});

setupMiddleware(app);
app.use('/', healthRoutes);

registerSocketEvents(io);

const PORT = process.env.PORT || 3500;
const HOST = process.env.HOST || '0.0.0.0';

server.listen(PORT, HOST, () => {
  console.log(`🚀 Server running at http://${HOST}:${PORT}`);
});










/*

/chatapp-backend
│
├── /src
│   ├── server.js               # Starts HTTP + WebSocket server
│   ├── index.js                # Optional: alternate entry point
│   ├── /routes                 # Express routes
│   │   └── health.js           # /healthz and /readyz
│   ├── /middleware             # Express middleware (helmet, cors, etc.)
│   │   └── setupMiddleware.js
│   ├── /socket
│   │   ├── index.js            # Registers socket handlers
│   │   ├── config.js           # Room capacity, rate limit config
│   │   ├── state.js            # In-memory store for rooms, sockets
│   │   ├── handlers/
│   │   │   ├── random.js       # Handles random chat logic
│   │   │   ├── rooms.js        # Handles join/create/leave-room
│   │   │   └── messages.js     # Handles chat-message
│   │   ├── utils/
│   │   │   ├── roomUtils.js    # roomExists, isRoomFull, etc.
│   │   │   ├── queue.js        # enqueue/dequeue logic
│   │   │   ├── rateLimiter.js  # Token bucket limiter
│   │   │   └── validators.js   # isNonEmptyString etc.
│
├── .env                        # Env config (PORT, etc.)
├── package.json 

*/