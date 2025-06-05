import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // App title and logo
                  _buildHeader(context),
                  const SizedBox(height: 40),
                  // Navigation card
                  _buildNavigationCard(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Constitution of Zimbabwe',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Explore and understand your rights',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationCard(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildActionButton(
              context,
              'View Constitution',
              Icons.book_outlined,
              '/constitution',
            ),
            const Divider(height: 24),
            _buildActionButton(
              context,
              'Search',
              Icons.search,
              '/search',
            ),
            const Divider(height: 24),
            _buildActionButton(
              context,
              'About Us',
              Icons.info_outline,
              '/about',
            ),
            const Divider(height: 24),
            _buildActionButton(
              context,
              'Chat with Us',
              Icons.chat_outlined,
              null,
              action: launchWhatsApp,
            ),

            // Only show Exit button on Android
            if (Platform.isAndroid) ...[
              const Divider(height: 24),
              _buildActionButton(
                context,
                'Exit',
                Icons.exit_to_app,
                null,
                action: () => SystemNavigator.pop(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    String? route, {
    VoidCallback? action,
  }) {
    return InkWell(
      onTap: action ??
          () {
            if (route != null) Navigator.pushNamed(context, route);
          },
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            size: 16,
          ),
        ],
      ),
    );
  }
}

// WhatsApp launcher function
void launchWhatsApp() async {
  final String contact = "+263775459788"; // Replace with your contact number
  final String text = 'Hi, I would like to know more about my constitution';

  final String androidUrl =
      "https://wa.me/$contact?text=${Uri.encodeComponent(text)}";
  final String iosUrl =
      "https://wa.me/$contact?text=${Uri.encodeComponent(text)}";
  final String webUrl =
      "https://api.whatsapp.com/send/?phone=$contact&text=${Uri.encodeComponent(text)}";

  try {
    // Check for Android, iOS, or web launch
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
