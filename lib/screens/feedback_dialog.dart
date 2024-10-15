import 'dart:typed_data'; // Add this for Uint8List
import 'package:flutter/material.dart';
import '../models/feedback.dart'; // Import the Feedback model (adjust to new class name)
import '../utils/feedback_helper.dart'; // Import the FeedbackHelper

class FeedbackDialog {
  static Future<void> showFeedbackDialog(BuildContext context, String userEmail) async {
    int rating = 1; // Default rating starts at 1
    TextEditingController suggestionsController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 16,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Feedback',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(color: Colors.lightBlueAccent),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Rate us:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                rating = index + 1; // Update rating based on user selection
                              });
                            },
                            child: Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 50, // Increased star size for better visibility
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Rating: $rating',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your Suggestions:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: suggestionsController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Enter your suggestions here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.all(12), // Add padding for text input
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Handle feedback submission
                          if (rating > 0) { // Ensure at least 1 star is selected
                            final feedback = UserFeedback( // Adjust to UserFeedback
                              rating: rating,
                              suggestions: suggestionsController.text,
                              userEmail: userEmail,
                            );
                            await FeedbackHelper().insertFeedback(feedback); // Save feedback to the database

                            print('Rating: $rating');
                            print('Suggestions: ${suggestionsController.text}');
                            print('User Email: $userEmail'); // Include email in the feedback

                            Navigator.of(context).pop(); // Close the dialog
                          } else {
                            // Show a message if no rating is selected
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Please select a rating before submitting.'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                        child: const Text(
                          'Submit Feedback',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
