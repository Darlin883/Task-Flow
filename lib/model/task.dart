class Task {
  final String id;
  final String title;
  final String category;
  final DateTime dueDate;
  final String priority;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json, String docId) {
    return Task(
      id: docId,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      dueDate: DateTime.parse(json['dueDate']),
      priority: json['priority'] ?? 'medium',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

List<String> categories = ['All', 'Work', 'Personal', 'Shopping'];