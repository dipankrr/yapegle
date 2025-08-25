import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';

export function setupMiddleware(app) {
  app.set('trust proxy', 1);
  app.use(helmet());
  app.use(cors({ origin: true, credentials: true }));
  app.use(morgan(process.env.NODE_ENV === 'production' ? 'combined' : 'dev'));
  app.use(express.json());
}