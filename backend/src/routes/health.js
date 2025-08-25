import express from 'express';

const router = express.Router();

router.get('/', (req, res) => {
  res.json({ status: 'ok', service: 'chat-backend', env: process.env.NODE_ENV, time: new Date().toISOString() });
});

router.get('/healthz', (req, res) => res.send('ok'));
router.get('/readyz', (req, res) => res.send('ready'));

export default router;