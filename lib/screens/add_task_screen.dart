import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController taskController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                  hintText: "Add Task",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 45,
              width: 200,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () async {
                    String taskName = taskController.text.trim();
                    if (taskName.isEmpty) {
                      Fluttertoast.showToast(msg: "Please Provide Task Name");
                      return;
                    }
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      String uid = user.uid;
                      int dt = DateTime.now().microsecondsSinceEpoch;
                      DatabaseReference taskRaf = FirebaseDatabase.instance
                          .reference()
                          .child("Tasks")
                          .child(uid);
                      String? taskId = taskRaf.push().key;
                      await taskRaf.child(taskId!).set({
                        "dt": dt,
                        "taskName": taskName,
                        "taskId": taskId,
                      });
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
