import 'package:flutter/material.dart';

class TextPage extends StatelessWidget {
  final String title;
  final String content;
  final String? image; // Optional image URL or asset

  const TextPage({
    Key? key,
    required this.title,
    required this.content,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.surface;
    final Color textColor = Theme.of(context)
        .colorScheme
        .onSurface
        .withOpacity(0.87); // Deeper, eye-comfort color
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
              backgroundColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image != null)
                  Center(
                    child: image!.startsWith('http')
                        ? Image.network(
                            image!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.broken_image,
                              size: 100,
                              color: Colors.grey,
                            ),
                          )
                        : Image.asset(
                            image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.image_not_supported,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style:
                        TextStyle(fontSize: 14, color: textColor, height: 1.6),
                    children: _parseContent(content),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Parses content to identify subscript text
  List<InlineSpan> _parseContent(String content) {
    final List<InlineSpan> spans = [];
    final RegExp regex = RegExp(r'\*(.*?)\*'); // Matches text between asterisks
    final matches = regex.allMatches(content);
    int lastMatchEnd = 0;

    for (final match in matches) {
      // Add normal text before the match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: content.substring(lastMatchEnd, match.start)));
      }

      // Add subscript text
      spans.add(
        WidgetSpan(
          child: Transform.translate(
            offset:
                const Offset(0, 3), // Adjusts vertical position for subscript
            child: Text(
              match.group(1)!, // Text inside the asterisks
              style: const TextStyle(fontSize: 12), // Smaller font size
            ),
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add remaining text after the last match
    if (lastMatchEnd < content.length) {
      spans.add(TextSpan(text: content.substring(lastMatchEnd)));
    }

    return spans;
  }
}
