import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/task.dart';
import '../widgets/task_card.dart';
import 'add_task_page.dart';
import 'task_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Work',
    'Personal',
    'Shopping',
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  CollectionReference<Map<String, dynamic>> get userTasksRef {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks');
  }

  bool _wasCompletedToday(Task task) {
    if (!task.isCompleted || task.completedAt == null) {
      return false;
    }

    final now = DateTime.now();
    final completed = task.completedAt!;

    return now.year == completed.year &&
        now.month == completed.month &&
        now.day == completed.day;
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    final newStatus = !task.isCompleted;

    await userTasksRef.doc(task.id).update({
      'isCompleted': newStatus,
      'completedAt':
          newStatus ? DateTime.now().toIso8601String() : null,
    });
  }

  Future<void> _deleteTask(Task task) async {
    await userTasksRef.doc(task.id).delete();
  }

  Future<void> _openTaskDetails(Task task) async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailPage(task: task),
      ),
    );

    if (updatedTask != null && updatedTask is Task) {
      await userTasksRef.doc(task.id).update({
        'isCompleted': updatedTask.isCompleted,
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('TaskFlow'),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.teal,
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.teal,
                ),
              ),
              accountName: const Text(
                'TaskFlow User',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ??
                    'No Email',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: _signOut,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                final isSelected =
                    selectedCategory == category;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.teal
                          : Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.black,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: userTasksRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final allTasks =
                    snapshot.data!.docs.map((doc) {
                  final task = Task.fromJson(
                    doc.data()
                        as Map<String, dynamic>,
                    doc.id,
                  );

                  if (task.isCompleted &&
                      !_wasCompletedToday(task)) {
                    userTasksRef.doc(task.id).update({
                      'isCompleted': false,
                      'completedAt': null,
                    });
                  }

                  return task;
                }).toList();

                final tasks =
                    selectedCategory == 'All'
                        ? allTasks
                        : allTasks
                            .where((task) =>
                                task.category ==
                                selectedCategory)
                            .toList();

                if (tasks.isEmpty) {
                  return Center(
                    child: Text(
                      selectedCategory == 'All'
                          ? 'No tasks yet'
                          : 'No $selectedCategory tasks yet',
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return Dismissible(
                      key: Key(task.id),
                      direction:
                          DismissDirection.endToStart,
                      background: Container(
                        alignment:
                            Alignment.centerRight,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) async {
                        await _deleteTask(task);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                '${task.title} deleted',
                              ),
                            ),
                          );
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          _openTaskDetails(task);
                        },
                        child: TaskCard(
                          task: task,
                          onToggleComplete: () =>
                              _toggleTaskCompletion(
                                  task),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTaskPage(),
            ),
          );

          if (!mounted) return;

          setState(() {
            selectedCategory = 'All';
            _currentIndex = 0;
          });
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            _scaffoldKey.currentState?.openDrawer();
            return;
          }

          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}