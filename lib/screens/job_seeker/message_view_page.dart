import 'package:flutter/material.dart';
import '../../models/message_model.dart';
import '../../utils/message_helper.dart';

class MessageViewPage extends StatefulWidget {
  const MessageViewPage({Key? key, required String userEmail}) : super(key: key);

  @override
  _MessageViewPageState createState() => _MessageViewPageState();
}

class _MessageViewPageState extends State<MessageViewPage> {
  late Future<List<MessageModel>> _messages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String email = ModalRoute.of(context)!.settings.arguments as String;
    _messages = _fetchMessages(email);
  }

  Future<List<MessageModel>> _fetchMessages(String email) async {
    final messageHelper = MessageHelper.instance;
    return await messageHelper.getMessagesForEmail(email);
  }

  void _showMessageDetails(MessageModel message) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Message Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.deepPurple,
                  ),
                ),
                Divider(color: Colors.grey, thickness: 1.5),
                SizedBox(height: 16),
                Text(
                  'Message:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  message.message,
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 16),
                Text(
                  'Sent by:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  message.fromEmail,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Time:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  message.timestamp,
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<MessageModel>>(
        future: _messages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No messages found.', style: TextStyle(fontSize: 18, color: Colors.grey)));
          } else {
            final messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return GestureDetector(
                  onTap: () => _showMessageDetails(message),
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Message: ${message.message}', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Sent by: ${message.fromEmail.isNotEmpty ? message.fromEmail : 'Unknown'}', style: TextStyle(color: Colors.grey)),
                          Text('Time: ${message.timestamp}', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
