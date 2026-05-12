class Task {
  final String id;
  final String title;
  final String category;
  final DateTime dueDate;
  final String priority;
  final bool isCompleted;
  final DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    this.completedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json, String docId) {
    return Task(
      id: docId,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      dueDate: DateTime.parse(json['dueDate']),
      priority: json['priority'] ?? 'medium',
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}