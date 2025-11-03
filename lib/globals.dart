import 'package:geolocator/geolocator.dart';

String globalUsername = '';
Position? globalPosition;

// Locally installed json server:
// json-server --watch db.json *or with string parsing file* npx json-server server.js
// GET/POST http://localhost:3000/ghost-types
// GET/POST http://localhost:3000/players
// GET/PUT/PATCH/DELETE http://localhost:3000/ghost-types/:id (same for players)
// It hot-reloads when you edit db.json.

// String server = "http://localhost:8084";
// String server = "http://localhost:3000";
// start localTunnel (correct port) for smartphone and copy url: lt --port 3000
// Visit this url in serving pc browser for password --> https://loca.lt/mytunnelpassword
String server = 'https://loose-masks-search.loca.lt';
