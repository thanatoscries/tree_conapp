import 'package:flutter/material.dart';
import 'content/all_chapters.dart';
import 'chapter_model.dart';
import 'text_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, String>> searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void performSearch(String query) {
    setState(() => _isSearching = true);

    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        _isSearching = false;
      });
      return;
    }

    List<Map<String, String>> results = [];

    void searchChapters(List<Chapter> chapters) {
      for (var chapter in chapters) {
        if (chapter.title.toLowerCase().contains(query.toLowerCase())) {
          results.add({
            'title': chapter.title,
            'content': chapter.content ?? '',
            'route': chapter.route ?? '',
          });
        }

        if (chapter.content != null &&
            chapter.content!.toLowerCase().contains(query.toLowerCase())) {
          results.add({
            'title': chapter.title,
            'content': chapter.content!,
            'route': chapter.route ?? '',
          });
        }

        if (chapter.subChapters != null) {
          searchChapters(chapter.subChapters!);
        }
      }
    }

    searchChapters(allChapters);

    // Delay to show searching animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Constitution'),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search field
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: performSearch,
                    decoration: InputDecoration(
                      hintText: 'Search constitution...',
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                performSearch('');
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Results count or placeholder text
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: _isSearching
                    ? Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Searching...',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        searchResults.isEmpty
                            ? _searchController.text.isEmpty
                                ? 'Start typing to search'
                                : 'No results found'
                            : '${searchResults.length} results found',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                      ),
              ),

              const SizedBox(height: 8),

              // Results list
              Expanded(
                child: searchResults.isEmpty && !_isSearching
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchController.text.isEmpty
                                  ? Icons.search
                                  : Icons.search_off,
                              size: 80,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'Search for content in the constitution'
                                  : 'No matching results found',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                searchResults[index]['title'] ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                searchResults[index]['content'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                String? route = searchResults[index]['route'];
                                String title =
                                    searchResults[index]['title'] ?? '';
                                String content =
                                    searchResults[index]['content'] ?? '';

                                if (route != null && route.isNotEmpty) {
                                  Navigator.pushNamed(context, route);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TextPage(
                                        title: title,
                                        content: content,
                                      ),
                                    ),
                                  );
                                }
                              },
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).colorScheme.primary,
                                size: 16,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
