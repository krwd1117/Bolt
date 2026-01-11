class NotionDatabase {
  final String id;
  final String title;

  const NotionDatabase({required this.id, required this.title});

  factory NotionDatabase.fromJson(Map<String, dynamic> json) {
    return NotionDatabase(
      id: json['id'] as String,
      title:
          json['title']
              as String, // Note: caller handles the complex title parsing if needed, but here we assume simple or caller does pre-processing.
      // Actually my notion_repository did pre-processing.
    );
  }
}
