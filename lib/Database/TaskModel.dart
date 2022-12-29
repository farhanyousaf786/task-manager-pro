
class


TaskModel {
  int? id;
  late String task;
  late String subTask;
  late String category;
  late String time;
  late String date;
  late String isComplete;

  // create the constructor
  TaskModel({
    this.id,
    required this.task,
    required this.subTask,
    required this.category,
    required this.time,
    required this.date,
    required this.isComplete,
  });

  // to save this data in database we need to convert it to a map
  // let's create a function for that
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'subtask': subTask,
      // it doesn't support the boolean either, so we save that as integer.
      'category': category,
      'time': time,
      'date': date,
      'isComplete': isComplete,
      // sqflite database doesn't support the datetime type so we will save it as Text.
    };
  }

  // this function is for debugging only
  @override
  String toString() {
    return 'TaskModel(id : $id, task : $task, subTask: $subTask, category : $category, time: $time, date : $date, isComplete: $isComplete)';
  }
}
