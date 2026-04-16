import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;


  const TaskCard({
    super.key,
    required this.task,

  });

  Color _priorityColor(){
    if(task.priority == "high") return Colors.red;
    if(task.priority == "medium") return  Colors.amber;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
    Container(
    padding: EdgeInsets.all(16),
    margin:EdgeInsets.symmetric(horizontal: 16,vertical: 16,),
    decoration: BoxDecoration(
    color:Colors.white,
    borderRadius: BorderRadius.circular(12),),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Container(
    width:4,
    height:40,
    color:_priorityColor(),
    ),
    Icon(Icons.task_alt_rounded,),
    Expanded(
    child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(task.title),
    ),

    ),
    Text(DateFormat("MMM D").format(task.dueDate))
    ],
    ),
    ),

        if (task.isCompleted)
          Positioned(
            top: 8,
            right: 8,
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
          ),
      ],
    );
  }
}
