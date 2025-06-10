class Blog {
  final String title;
  final String link;
  final DateTime pubDate;
  final String thumbnail;   // can be empty
  final String description; // plain-text summary

  const Blog({
    required this.title,
    required this.link,
    required this.pubDate,
    required this.thumbnail,
    required this.description,
  });
}
