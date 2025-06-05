class Chapter {
  final String title; // Chapter title
  final String? content; // Optional for sections with direct content
  final String? route; // Navigation route for deeper linking
  final List<Chapter>? subChapters; // Nested structure

  Chapter({required this.title, this.content, this.route, this.subChapters});
}
