import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:ratiba_app/configs/constants.dart';
import 'package:ratiba_app/controllers/task_controller.dart';
import 'package:ratiba_app/models/task_model.dart';
import 'package:ratiba_app/views/add_task.dart';
import 'package:ratiba_app/views/components/customText.dart';

TaskController taskController = Get.put(TaskController());

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _BoardState();
}

class _BoardState extends State<Home> {
  final SearchController _searchController = SearchController();
  bool showNoData = false;

  @override
  void initState() {
    super.initState();
    getTasks();

    Timer(
      const Duration(seconds: 6),
      () {
        if (taskController.taskList.isEmpty) {
          setState(() {
            showNoData = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // getTasks();
    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: baseColor,
        centerTitle: true,
        title: const customText(
          label: "Tasks To Do",
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () => Get.offAndToNamed("/"),
              child: const Icon(
                Icons.output_rounded,
                size: 32,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          if (showNoData) {
            return Center(
              child: Column(
                children: [
                  Lottie.network(
                      'https://lottie.host/730a99d0-773b-43d9-8802-81ab339f51a4/JUTQ5PziHR.json'),
                  const customText(
                    label: 'Add Tasks',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            );
          }

          if (taskController.taskList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Area
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SearchAnchor(
                    builder:
                        (BuildContext context, SearchController controller) {
                      return SearchBar(
                        controller: _searchController,
                        padding: const WidgetStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16.0)),
                        onTap: () {
                          _searchController.openView();
                        },
                        onChanged: (query) {
                          taskController.filterTask(query);
                          _searchController.openView();
                        },
                        leading: const Icon(Icons.search),
                      );
                    },

                    // Builds a list of suggestions based on user's input
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      return List<ListTile>.generate(5, (int index) {
                        final String item = 'item $index';
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              controller.closeView(item);
                            });
                          },
                        );
                      });
                    },
                  ),
                ),

                // Task List
                Obx(
                  () {
                    if (taskController.filteredTaskList.isEmpty) {
                      return Center(
                        child: Lottie.network(
                            'https://lottie.host/730a99d0-773b-43d9-8802-81ab339f51a4/JUTQ5PziHR.json'),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: taskController.filteredTaskList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    label:
                                        "${taskController.filteredTaskList[index].task}",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        label:
                                            "Category: ${taskController.filteredTaskList[index].category}",
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      customText(
                                        label:
                                            "Due Date: ${taskController.filteredTaskList[index].due_date}",
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: const customText(
                                              label:
                                                  "Do you want to delete this Task",
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            actions: [
                                              // Cancel Button
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        Navigator.pop(context),
                                                    child: const customText(
                                                      label: "Cancel",
                                                      labelColor: Colors.green,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),

                                                  // Yes Button
                                                  GestureDetector(
                                                    onTap: () {
                                                      deleteTask(
                                                        taskController
                                                            .filteredTaskList[
                                                                index]
                                                            .id,
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                    child: const customText(
                                                      label: "Yes",
                                                      labelColor: Colors.red,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ));
                                },
                                child: const customText(
                                  label: "DELETE",
                                  fontWeight: FontWeight.bold,
                                  labelColor: Colors.red,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/add_task');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Connecting to API to Pull Tasks
  Future<void> getTasks() async {
    http.Response response;
    response = await http.get(
      Uri.parse(
          "https://mmogaya.com/ratiba/task.php?user_id=${signInController.userId.value}"),
    );

    if (response.statusCode == 200) {
      var serverResponse = json.decode(response.body);
      var boardResponse = serverResponse['tasks'] as List;
      taskController.updateTaskList(
          boardResponse.map((task) => TaskModel.fromJson(task)).toList());
    } else {
      print("Error Occurred");
    }
  }

  // Delete Task Logic
  Future<void> deleteTask(taskId) async {
    http.Response response;
    response = await http.get(
      Uri.parse(
        "https://mmogaya.com/ratiba/delete_task.php?id=$taskId",
      ),
    );
    if (response.statusCode == 200) {
      // Snackbar to notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Task Deleted Successfully",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
      getTasks();
    } else {
      print("Error Ocurred");
    }
  }
}
