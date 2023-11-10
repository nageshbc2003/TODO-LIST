import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ToAddPage extends StatefulWidget {
  final Map? todo;
  const ToAddPage({
    super.key,
    this.todo,
  });

  @override
  State<ToAddPage> createState() => _ToAddPageState();
}

class _ToAddPageState extends State<ToAddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit=false;
  @override
  void initState() {

    super.initState();
    final todo =widget.todo;
    if(todo!=null)
    {
      isEdit=true;
      final title=todo['title'];
      final description=todo['description'];
      titleController.text=title;
      descriptionController.text=description;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Center(
          child: Text(
              isEdit? "Edit your Task":
              "Add Task"),
        ),
      ),
      body:
      ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(height: 40,),

          TextField(
            controller: titleController,
            decoration: InputDecoration(
                hintText: "Title"
            ),
          ),
          SizedBox(height: 30,),

          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
                hintText: "Description"

            ),
            minLines: 5,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
          ),
          SizedBox(height: 50,),
          ElevatedButton(

            onPressed: isEdit? updateData: submitData,

              child: Padding(

                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(

                      isEdit?"Update":  "Submit",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                  ),
                ),
              ),

          ),

        ],
      ),
    );
  }
  Future <void> updateData() async{
    final todo=widget.todo;
    if(todo == null){
      print("You cannot call update without todo data");
      return;
    }
    final id =todo['_id'] ;
    final title = titleController.text;
    final description = descriptionController.text;
    final body =
    {

      "title": title,
      "description": description,
      "is_completed":false,
    };

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {

      showSuccessMessasge("Successfully updated");
    }
    else {
      showErrorMessasge("Update failed");

    }
  }


  Future <void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body =
    {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 201) {
      titleController.text='';
      descriptionController.text='';
      showSuccessMessasge("Successfully Added");
    }
    else {
      showErrorMessasge("unable to add ");

    }
  }

  void showSuccessMessasge(String message) {
    final snackBar = SnackBar(content: Text(message,
      style: TextStyle(
          color: Colors.white
      ),
    ),
      backgroundColor: Colors.green[900],

    )
    ;
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessasge(String message) {
    final snackBar = SnackBar(content: Text(message,
      style: TextStyle(
          color: Colors.white
      ),
    ),

      backgroundColor: Colors.red[900],


    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}