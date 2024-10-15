import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import '../../models/message_model.dart';
import '../../utils/message_helper.dart'; // Import the helper

class SendMessagePage extends StatefulWidget {
  final String jobSeekerEmail;
  final String providerEmail;

  SendMessagePage({required this.jobSeekerEmail, required this.providerEmail});

  @override
  _SendMessagePageState createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  // Method to save message to the database
  Future<void> _saveMessage() async {
    if (messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message cannot be empty!')),
      );
      return;
    }

    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final newMessage = MessageModel(
      fromEmail: widget.providerEmail,
      toEmail: widget.jobSeekerEmail,
      message: messageController.text.trim(),
      timestamp: timestamp,
    );

    // Save message to the database
    final messageHelper = MessageHelper.instance;
    await messageHelper.insertMessage(newMessage);

    // Show success message and close the dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message sent and saved!')),
    );
    Navigator.of(context).pop(); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Send Message'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // From Email Field (Read-only)
          TextFormField(
            initialValue: widget.providerEmail,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'From',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          // To Email Field (Read-only)
          TextFormField(
            initialValue: widget.jobSeekerEmail,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'To',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          // Message Input Field
          TextField(
            controller: messageController,
            decoration: InputDecoration(
              labelText: 'Message',
              hintText: 'Type your message here...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saveMessage, // Call save message method
          child: Text('Send'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without action
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

