import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/screens/profile_screen.dart';

import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key})
      : super(key: key); // Corrected 'super.key' to 'key'

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  User? user;
  DatabaseReference? taskRef;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      taskRef =
          FirebaseDatabase.instance.reference().child("tasks").child(user!.uid);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Task List"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ProfileScreen()));
              },
              icon: Icon(Icons.person),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return CupertinoAlertDialog(
                        title: Text("Confirmation"),
                        content: Text("Are You Sure To Log Out"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) {
                                return LogInScreen();
                              }));
                            },
                            child: Text("Yes"),
                          ),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.logout),
            ),
            SizedBox(width: 8)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => AddTaskScreen()));
          },
          child: Icon(Icons.add),
        ),
        body: StreamBuilder(
            stream: taskRef != null ? taskRef!.onValue : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text("No task added yet"));
              } else {
                var event =
                    snapshot.data as DatabaseEvent; // The type is DatabaseEvent

                var snapshot2 =
                    event!.snapshot; // Access the snapshot from the event

                Map<String, dynamic> map = <String, dynamic>{};
                if (snapshot2.value is Map) {
                  map = Map<String, dynamic>.from(snapshot2 as Map);
                }

                var taskList = <TaskModel>[];
                map.forEach((key, value) {
                  var taskModel = TaskModel.fromMap(value);
                  taskList.add(taskModel);
                });

                return Center(child: Text(taskList.length.toString()));
              }
            }));
  }
}
/* StreamBuilder(
            stream: taskRef != null ? taskRef!.onValue : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text("No task added yet"));
              } else {
                DatabaseEvent? event =
                    snapshot.data; // The type is DatabaseEvent

                var snapshot2 =
                    event!.snapshot; // Access the snapshot from the event

                Map<String, dynamic> map = <String, dynamic>{};
                if (snapshot2.value is Map) {
                  map = Map<String, dynamic>.from(snapshot2 as Map);
                }

                var taskList = <TaskModel>[];
                map.forEach((key, value) {
                  var taskModel = TaskModel.fromMap(value);
                  taskList.add(taskModel);
                });

                return ListView.builder(
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      TaskModel task = taskList[index];
                      return Container(
                        color: Colors.grey,
                        child: Column(
                          children: [
                            Text(
                              task.taskName,
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(task.taskId.toString()),
                            Icon(Icons.delete_outline_outlined)
                          ],
                        ),
                      );
                    });
              }
            }));*/
