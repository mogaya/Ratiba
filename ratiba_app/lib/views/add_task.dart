import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ratiba_app/configs/constants.dart';
import 'package:ratiba_app/controllers/sign_in_controller.dart';
import 'package:ratiba_app/views/components/customButton.dart';
import 'package:ratiba_app/views/components/customDetailsInput.dart';
import 'package:ratiba_app/views/components/customText.dart';

SignInController signInController = Get.put(SignInController());

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  AddTaskState createState() => AddTaskState();
}

class AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dueDate = TextEditingController();
  final TextEditingController task = TextEditingController();
  final TextEditingController category = TextEditingController();

  // Method to display the date picker and update the text field
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date is shown by default
      firstDate: DateTime(2000), // The earliest date allowed
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Header background color
            hintColor: Colors.blue, // Selection color
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Header text color
              onPrimary: Colors.white, // Header text on color
              onSurface: Colors.black, // Body text color
            ),
            dialogBackgroundColor:
                Colors.white, // Background color of the dialog
            textTheme: const TextTheme(
              headlineMedium: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold), // Selected date
              bodyMedium: TextStyle(fontSize: 16, color: Colors.grey),
              // Days on the calendar
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                // primary: Colors.blue, // Button text color
                textStyle: const TextStyle(
                  fontSize: 18, // Set your desired font size here
                  fontWeight: FontWeight.bold, // Set your desired font weight
                ),
              ),
            ),
          ),
          child: child!,
        );
      }, // The latest date allowed
    );

    if (picked != null) {
      setState(() {
        // Formatting the date to a readable format
        _dueDate.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        backgroundColor: baseColor,
        shadowColor: baseColor,
        centerTitle: true,
        title: const customText(
          label: 'Add Task',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 650,
              maxWidth: 320,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Task Input
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: customText(
                        label: "Task",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  customDetailsInput(
                    controller: task,
                    hintMessage: 'Enter Task Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Task Name is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // Category Input
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: customText(
                        label: "Task Category",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  customDetailsInput(
                    controller: category,
                    hintMessage: 'Enter Task Category',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Task Category is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // due_date input
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: customText(
                        label: "Due Date",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _dueDate,
                    readOnly:
                        true, // So the user cannot directly type in the date
                    decoration: const InputDecoration(
                      labelText: 'Select Due Date',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      errorStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon:
                          Icon(Icons.calendar_today), // Adds a calendar icon
                    ),
                    onTap: () {
                      // When tapped, show the date picker
                      _selectDate(context);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Due Date is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // Save Button
                  SizedBox(
                    width: 350,
                    child: customButton(
                      text: "SAVE",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          AddTask();
                        }
                      },
                      txtFontWeight: FontWeight.bold,
                      txtFontSize: 18,
                      color: ascentColor,
                      txtColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // AddTask logic
  Future<void> AddTask() async {
    http.Response response;
    var body = {
      'user_id': '${signInController.userId.value}',
      'task': task.text.trim(),
      'category': category.text.trim(),
      'due_date': _dueDate.text.trim(),
    };

    response = await http.post(
      Uri.parse("https://mmogaya.com/ratiba/add_task.php"),
      body: body,
    );

    if (response.statusCode == 200) {
      var serverResponse = json.decode(response.body);
      int success = serverResponse['success'];

      // Snackbar to notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Task Added Successfully",
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

      if (success == 1) {
        Get.toNamed("/home");
      }
    }
  }
}
