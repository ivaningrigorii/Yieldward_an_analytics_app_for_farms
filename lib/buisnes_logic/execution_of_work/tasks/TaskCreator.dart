import 'package:flutter/material.dart';

import '../../../data_logic/models/dbtask.dart';

class TaskCreatorWidget extends StatelessWidget {
  final DateTime? seldate;

  const TaskCreatorWidget({super.key, required this.seldate});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showTaskCreationDialog(context);
      },
      child: Text('Добавить задачу'),
    );
  }

  void _showTaskCreationDialog(BuildContext context) {
    TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Создать задачу'),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(hintText: 'Объём работы (число в Га)')
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                String taskDescription = taskController.text;
                if (taskDescription.isNotEmpty) {
                  Task newTask = Task(
                    volume_of_fieldwork: int.parse(taskDescription),
                    description: "",
                    date_task: seldate!.toIso8601String(),
                    exec: 0, id_fieldwork: 1,
                  );
                  insertTask(newTask);
                  Navigator.of(context).pop();
                } else {
                }
              },
              child: Text('Создать'),
            ),
          ],
        );
      },
    );
  }
}