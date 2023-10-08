import 'dart:io';
import 'dart:convert';

void connectToServer() async {
  Socket socket = await Socket.connect('127.0.0.1', 5000);

  // Listen to the server
  socket.listen(
    (List<int> data) {
      print(utf8.decode(data));
    },
    onError: (error) {
      print(error);
    },
    onDone: () {
      socket.destroy();
    },
  );

  // Send data to the server
  socket.add(utf8.encode('Hello from Flutter!'));
  await socket.flush();
}
