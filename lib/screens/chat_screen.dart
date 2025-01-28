import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = 'AIzaSyCYwUIfwmenL0BJ7nE5oEJkbYbpbZYfTes'; // Replace with your actual Gemini API key

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini Chat',
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<Map<String, dynamic>> _messages = []; // Supports both text and image messages
  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
  }

  /// Process Image and Send to Gemini
  void _sendImageMessage(File image) async {
    setState(() {
      _messages.add({'type': 'image', 'content': image});
    });

    // For demonstration, describe the image manually
    // Replace this part with OCR or captioning if supported by your app
    String imageDescription = "This is an image uploaded by the user.";

    try {
      final response = await _model.generateContent([Content.text(imageDescription)]);
      setState(() {
        _messages.add({'type': 'response', 'content': response.text});
      });
    } catch (e) {
      setState(() {
        _messages.add({'type': 'response', 'content': 'Error analyzing the image.'});
      });
    }
  }

  /// Pick Image from Gallery
  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _sendImageMessage(File(image.path));
    }
  }

  /// Send Text Message
  void _sendTextMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({'type': 'text', 'content': _controller.text});
      });

      try {
        final response = await _model.generateContent([Content.text(_controller.text)]);
        setState(() {
          _messages.add({'type': 'response', 'content': response.text});
        });
      } catch (e) {
        setState(() {
          _messages.add({'type': 'response', 'content': 'Error fetching response.'});
        });
      }

      _controller.clear();
    }
  }

  /// Build Chat Bubbles
  Widget _buildMessageBubble(Map<String, dynamic> message) {
    if (message['type'] == 'text') {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message['content'],
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } else if (message['type'] == 'response') {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message['content'],
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );
    } else if (message['type'] == 'image') {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Image.file(
            message['content'],
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[_messages.length - 1 - index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.orange),
                  onPressed: _pickImage, // Trigger image picker
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.orange),
                  onPressed: _sendTextMessage, // Send text message
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
