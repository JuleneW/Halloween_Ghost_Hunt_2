// import jsonServer from 'C:\Users\julen\AppData\Roaming\npm\node_modules'
import { create, router as _router, defaults } from 'json-server';
import fs from 'fs';

const server = create();
const router = _router('db.json');
const middlewares = defaults();

server.use(middlewares);

// middleware to force numeric ids for /players
server.post('/players', (req, res, next) => {
  const db = JSON.parse(fs.readFileSync('db.json', 'utf-8'));
  const players = db.players || [];

  const maxId = players.reduce((max, p) => {
    const num = typeof p.id === 'number' ? p.id : parseInt(p.id, 10);
    return !isNaN(num) && num > max ? num : max;
  }, 0);

  req.body.id = maxId + 1; // <- force numeric id
  next();
});

server.use(router);

server.listen(3000, () => {
  console.log('JSON server with numeric player ids on 3000');
});
