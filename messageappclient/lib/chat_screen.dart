import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = []; // List to store messages
  late Socket _socket; // TCP client socket

  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  _initSocket() async {
    try {
      _socket = await Socket.connect('127.0.0.1', 5000);
      _socket.listen(
        (List<int> data) {
          final message = utf8.decode(data);
          setState(() {
            _messages.add(message); // Adding the message to the list
          });
        },
        onError: (error) {
          print("Socket Error: $error");
        },
        onDone: () {
          print("Socket has been closed");
        },
      );
    } catch (error) {
      print("Error connecting to the server: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat App")),
      body: Column(
        children: [
          // Displaying the messages
          Flexible(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(message: _messages[index]);
              },
            ),
          ),
          const Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              decoration:
                  const InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessage(_textController.text);
              _textController.clear();
            },
          ),
        ],
      ),
    );
  }

  _sendMessage(String message) {
    if (message.isNotEmpty) {
      _socket.add(utf8.encode(message));
      _socket.flush();
    }
  }
}

class MessageBubble extends StatelessWidget {
  final String message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(message),
      ),
    );
  }
}
