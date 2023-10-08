# MessagingApp
Console app with the name messageappserver is created. This console app has a listener and a list of clients currently connected on. THreads are also locked to avoid complications with connections.

The console app listens for all TCP connections. Once it is executed, everyone can connect and participate. Clients are handled and the text sent is later then encoded.

Flutter application is also created with a listview. This app connects to the websocket and is able to send text messages to the screen.

This application is a sample app for a chat messaging app. Initial study repos were:

https://github.com/Hakkology/WebSocket 
https://github.com/Hakkology/WebSocketApp

To be modified further later on with final touches...
