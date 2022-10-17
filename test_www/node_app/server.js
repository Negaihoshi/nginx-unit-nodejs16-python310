#!/usr/bin/env node

import cors from 'cors';
import express from "express";
import path from 'path';
import serveStatic from 'serve-static';
import { fileURLToPath } from 'url'
import { handler } from './build/handler.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const port = process.env.PORT || 9000;

const app = express();
app.use(cors());

app.get('/health', (req, res) => {
  res.end('ok');
});

app.use(serveStatic(path.join(__dirname, 'build')));
app.use(serveStatic(path.join(__dirname, 'src')));
app.use(serveStatic(path.join(__dirname, 'static')));
app.use(handler);

app.listen(port, () => {
   console.log(`Server is up on port ${port}`);
});
