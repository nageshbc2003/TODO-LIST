import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sampleoftodolist/AddPage.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading=false;
  List items=[];
  @override
  void initState() {

    super.initState();
    FetchTodo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton.extended(

          icon: Icon(
            Icons.add,
          ),
          onPressed: navigateToAddPage ,label:  Text("Add Task")),
      appBar: AppBar(
        title:  Center(child: Text("Your Tasks")),
      ),
      body:
      Visibility(

        child: RefreshIndicator(
          onRefresh: FetchTodo,
          child: ListView.builder(
            itemCount: items.length,
              itemBuilder: (context, index) {
              final item=items[index] as Map;
              final id=item['_id'] as String;

            return ListTile(
              leading: CircleAvatar(child: Text('${index+1}')),
            title: Text(item['title']),
              subtitle: Text(item['description']),
              trailing: PopupMenuButton(
              onSelected: (value) {
                if (value == "edit") {
                    navigateToEditPage(item);
                }
                else if (value == "delete") {
                  deleteById(id);
                }
              },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text("Edit"),
                      value:"edit",
                    ),

                    PopupMenuItem(
                      child: Text("Delete"),
                      value: "delete",
                    )
                  ];

                },
              )
            );
    }
    ),
        ),
      ),
    );
  }

  Future<void>  navigateToEditPage(Map item)  async {
    final route = MaterialPageRoute(builder: (context) => ToAddPage(todo: item,),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading=true;
    });
    FetchTodo();
  }

    Future<void> navigateToAddPage() async{
   final route=MaterialPageRoute(builder: (context)=> ToAddPage(),
    );
    await Navigator.push(context, route);
 setState(() {
   isLoading=true;
 });
    FetchTodo();

  }
   Future<void> deleteById(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id' ] != id).toList();
      setState(() {
        items = filtered;
      });
    }
    else {

    }
  }


  Future<void> FetchTodo() async{
    setState(() {
      isLoading=false;
    });
    final url="https://api.nstack.in/v1/todos?page=1&limit=20";
    final uri=Uri.parse(url);
    final response= await http.get(uri);
   if(response.statusCode==200){
     final json=jsonDecode(response.body) as Map;
     final result=json['items'] as List;
     setState(() {
       items=result;
     });


   }
   else{
  showErrorMessasge("unable to delete");
   }





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



