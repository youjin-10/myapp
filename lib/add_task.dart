import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  final void Function({required String twodoText}) addTwodo;
  const AddTask({super.key, required this.addTwodo});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var twodoText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2114024400.
      children: [
        const Text("add task"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: twodoText,
            decoration: const InputDecoration(
              hintText: "Add Task here"
            ),
          ),
        ),
        ElevatedButton(onPressed: (){
          widget.addTwodo(twodoText: twodoText.text);
          twodoText.clear();
        }, child: const Text("Add"))
      ],
    );
  }
}