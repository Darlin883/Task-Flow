import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/task.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;

  const TaskDetailPage({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    bool updatedStatus = task.isCompleted;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Category: ${task.category}'),
                const SizedBox(height: 8),
                Text('Priority: ${task.priority}'),
                const SizedBox(height: 8),
                Text('Due Date: ${DateFormat("MMM d, yyyy").format(task.dueDate)}'),
                const SizedBox(height: 8),
                Text('Status: ${updatedStatus ? "Completed" : "Pending"}'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setModalState(() {
                      updatedStatus = !updatedStatus;
                    });
                  },
                  child: Text(
                    updatedStatus ? 'Mark Pending' : 'Mark Complete',
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      Task(
                        id: task.id,
                        title: task.title,
                        category: task.category,
                        dueDate: task.dueDate,
                        priority: task.priority,
                        isCompleted: updatedStatus,
                      ),
                    );
                  },
                  child: const Text('Save and Close'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}