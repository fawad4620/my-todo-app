class TaskModel {
  final String taskId;
  final String taskName;
  final int dt;

  TaskModel({required this.taskId, required this.taskName, required this.dt});

  static TaskModel fromMap(Map<String, dynamic> map) {
    return TaskModel(
        taskId: map['taskId'], // Use "as String" for null-safety
        taskName: map['taskName'], // Use "as String" for null-safety
        dt: map['dt'] // Use "as int" for null-safety
        );
  }
}
