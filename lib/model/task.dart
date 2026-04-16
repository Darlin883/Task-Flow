

class Task {
  final int id;
  final String title;
  final String category;
  final DateTime dueDate;
  final  String priority;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
});

}

List<Task> dummyTasks=[
  Task(
    id:1,
    title:"Walk Dog",
    category: "Personal",
    dueDate: DateTime(2026,4,16),
    priority: "high",
    isCompleted: false,
  ),
  Task(
    id:2,
    title:"Walk Cat",
    category: "Personal",
    dueDate: DateTime(2026,5,16),
    priority: "medium",
    isCompleted: false,
  ),
  Task(
    id:3,
    title:"Walk Boss Croc",
    category: "Work",
    dueDate: DateTime(2026,4,21),
    priority: "high",
    isCompleted: false,
  ),
  Task(
    id:4,
    title:"Walk Friend",
    category: "Personal",
    dueDate: DateTime(2026,4,17),
    priority: "hard",
    isCompleted: false,
  ),
  Task(
    id:5,
    title:"Eat Food",
    category: "Personal",
    dueDate: DateTime(2026,4,16),
    priority: "hard",
    isCompleted: false,
  ),
  Task(
    id:6,
    title:"Workout",
    category: "Personal",
    dueDate: DateTime(2026,4,15),
    priority: "hard",
    isCompleted: true,
  ),
  Task(
    id:7,
    title:"Drink Water",
    category: "Personal",
    dueDate: DateTime(2026,4,15),
    priority: "medium",
    isCompleted: true,
  ),Task(
    id:8,
    title:"Hike",
    category: "Personal",
    dueDate: DateTime(2026,4,15),
    priority: "",
    isCompleted: true,
  ),
];
List<String> categories = ['All', 'Work', 'Personal', 'Shopping'];