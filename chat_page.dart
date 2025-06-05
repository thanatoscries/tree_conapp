import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Us'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Call the function to launch WhatsApp
            launchWhatsApp();
          },
          child: Text('Chat with Us on WhatsApp'),
        ),
      ),
    );
  }
}

// Function to launch WhatsApp
void launchWhatsApp() async {
  final String contact = "+263789905942"; // Replace with your contact number
  final String text = 'Hi, I would like to know more about my constitution';

  final String androidUrl =
      "https://wa.me/$contact?text=${Uri.encodeComponent(text)}";
  final String iosUrl =
      "https://wa.me/$contact?text=${Uri.encodeComponent(text)}";
  final String webUrl =
      "https://api.whatsapp.com/send/?phone=$contact&text=${Uri.encodeComponent(text)}";

  try {
    // Check and launch for Android or iOS URLs
    if (await canLaunchUrl(Uri.parse(androidUrl))) {
      await launchUrl(Uri.parse(androidUrl));
    } else if (await canLaunchUrl(Uri.parse(iosUrl))) {
      await launchUrl(Uri.parse(iosUrl));
    } else {
      await launchUrl(
          Uri.parse(webUrl)); // Launch the web version if mobile fails
    }
  } catch (e) {
    print('Error launching WhatsApp: $e');
  }
}
