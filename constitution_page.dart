import 'package:flutter/material.dart';
import 'content/all_chapters.dart';
import 'chapter_model.dart';

class ConstitutionPage extends StatefulWidget {
  const ConstitutionPage({Key? key}) : super(key: key);

  @override
  State<ConstitutionPage> createState() => _ConstitutionPageState();
}

class _ConstitutionPageState extends State<ConstitutionPage> {
  // Track expanded state manually
  final Map<String, bool> _expandedNodes = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Constitution'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTreeView(allChapters),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTreeView(List<Chapter> chapters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: chapters.asMap().entries.map((entry) {
        int index = entry.key;
        Chapter chapter = entry.value;
        return _buildChapterItem(chapter, index.toString());
      }).toList(),
    );
  }

  Widget _buildChapterItem(Chapter chapter, String nodeKey) {
    final bool hasSubchapters =
        chapter.subChapters != null && chapter.subChapters!.isNotEmpty;
    final bool isExpanded = _expandedNodes[nodeKey] ?? false;
    final textColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.87);
    final nodeColor = hasSubchapters
        ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7)
        : Theme.of(context).colorScheme.surface;

    return Padding(
      padding: EdgeInsets.only(
        left: nodeKey.split('.').length > 1 ? 16.0 : 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: isExpanded ? 2 : 0,
            margin: const EdgeInsets.symmetric(vertical: 3.0),
            color: nodeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isExpanded
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                    : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                width: isExpanded ? 1.0 : 0.5,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                if (hasSubchapters) {
                  setState(() {
                    _expandedNodes[nodeKey] = !isExpanded;
                  });
                } else if (chapter.route != null) {
                  Navigator.pushNamed(context, chapter.route!);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: Row(
                  children: [
                    if (hasSubchapters)
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 300),
                        turns: isExpanded ? 0.25 : 0,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: textColor,
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          Icons.article_outlined,
                          size: 16,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        chapter.title,
                        style: TextStyle(
                          fontSize: nodeKey.split('.').length > 1 ? 15 : 16,
                          color: textColor,
                          fontWeight: nodeKey.split('.').length > 1
                              ? FontWeight.normal
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (hasSubchapters && isExpanded)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: chapter.subChapters!
                    .asMap()
                    .entries
                    .map((entry) =>
                        _buildChapterItem(entry.value, '$nodeKey.${entry.key}'))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
