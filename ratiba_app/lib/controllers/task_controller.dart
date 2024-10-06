import 'package:get/get.dart';

class TaskController extends GetxController {
  var taskList = [].obs;
  var filteredTaskList = [].obs;

  updateTaskList(list) {
    taskList.value = list;
    filteredTaskList.value = list;
  }

  void filterTask(String query) {
    if (query.isEmpty) {
      filteredTaskList.value =
          taskList; // Reset to original list if query is empty
    } else {
      filteredTaskList.value = taskList
          .where((task) =>
              task.task.toLowerCase().contains(query.toLowerCase()) ||
              task.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
