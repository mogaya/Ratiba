class TaskModel {
  var id;
  var task;
  var category;
  var due_date;
  var created_at;

  TaskModel({
    this.id,
    this.task,
    this.category,
    this.created_at,
    this.due_date,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      task: json['task'],
      category: json['category'],
      due_date: json['due_date'],
      created_at: json['created_at'],
    );
  }
}
