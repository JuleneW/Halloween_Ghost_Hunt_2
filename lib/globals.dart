import 'package:geolocator/geolocator.dart';

String globalUsername = '';
Position? globalPosition;

// Update server mobile/local json server/spring backend/ngrok
// also update endpoint in inventoryItem.api.dart when switching from json server

// Locally installed json server: json-server --watch db.json
String server = "http://localhost:3000";

// Spring API backend: Open Ghost Hunt backend in IntelliJ and open docker engine --> docker-compose up
// String server = "http://localhost:8084";

// start localTunnel ( + correct port) for smartphone and copy url: lt --port 'port'
// Visit this url in serving pc browser for password --> https://loca.lt/mytunnelpassword
// String server = 'https://dark-lands-rescue.loca.lt';

// Ngrok server ( + backend port): ngrok http 'port'
// String server = 'https://mao-subtympanitic-pauletta.ngrok-free.dev';


// String server = 'http://192.168.0.86:8084';