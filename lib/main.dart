import 'package:flutter/material.dart';
import 'package:task_flow_manager/model/task.dart';
import 'package:task_flow_manager/pages/home_page.dart';
import 'package:task_flow_manager/widgets/task_card.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TaskFlow'),
          backgroundColor: Colors.teal,
        ),
        body: Column(
          children: [
            SizedBox(
              height:40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context,index){
                return Container(
                  margin:EdgeInsets.symmetric(horizontal: 8),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color:Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:Text(categories[index]),
                );
              },
              ),
            ),
            Expanded(
              child: ListView.separated(
                  itemCount:dummyTasks.length,
                  itemBuilder: (context , index){
                    return TaskCard(task: dummyTasks[index]);
                  },
                separatorBuilder: (BuildContext context, int index)  => SizedBox(height: 8,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

