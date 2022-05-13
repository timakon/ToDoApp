import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth.dart';

import '../domain/todo_item.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Color(0xFF303e45),
          title: Text("ToDoApp"),
          leading: Icon(Icons.list_alt_outlined),
          actions: <Widget>[
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.logout),
              color: Colors.white,
              tooltip: 'Logout',
              onPressed: () {
                AuthService().logOut();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color(0xFFCFD8DC),
                    title: const Text(
                      "Add your task",
                      style: TextStyle(color: Color(0xFF212121), fontSize: 25),
                    ),
                    content: DialogInputs(),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance.collection("todos").add({"title": DialogInputs._titleController.text,
                              "description":DialogInputs._descriptionController.text, "uid":FirebaseAuth.instance.currentUser?.uid
                            });

                            DialogInputs._titleController.clear();
                            DialogInputs._descriptionController.clear();
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Add",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF009688),
                            primary: Color(0xFF757575),
                          ))
                    ],
                  );
                });
          },
          backgroundColor: Color(0xFF009688),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('todos').where("uid", isEqualTo:FirebaseAuth.instance.currentUser?.uid).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Text("No ToDo yet!");
            return Container(
                  child: Container(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int i) {
                          final todo = snapshot.data!.docs[i];
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              FirebaseFirestore.instance.collection('todos').doc(snapshot.data!.docs[i].id).delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(todo.get('title') + ' dismissed')));
                            },
                            background: Container(
                              color: Colors.red,
                              margin: EdgeInsets.symmetric(vertical: 4),
                            ),
                            child: Card(
                              elevation: 2.0,
                              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Container(
                                decoration: BoxDecoration(color: Color(0xFF455A64)),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                  title: Container(
                                    padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
                                    child: Text(
                                      todo.get('title'),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  subtitle: Container(
                                    padding: EdgeInsets.only(left: 20, bottom: 10),
                                    child: Text(todo.get('description'),
                                        style:
                                            TextStyle(color: Colors.white, fontSize: 20)),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                );
          },
        ),
      ),
    );
  }
}

class DialogInputs extends StatelessWidget {
  static TextEditingController _titleController = TextEditingController();
  static TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Column(children: <Widget>[
        TextField(
          controller: _titleController,
          style: const TextStyle(fontSize: 20, color: Color(0xFF212121)),
          decoration: const InputDecoration(
            hintStyle:
                TextStyle(fontSize: 20, color: Color.fromARGB(125, 33, 33, 33)),
            hintText: "Title",
          ),
        ),
        TextField(
          controller: _descriptionController,
          style: const TextStyle(fontSize: 20, color: Color(0xFF212121)),
          decoration: const InputDecoration(
            hintStyle:
                TextStyle(fontSize: 20, color: Color.fromARGB(125, 33, 33, 33)),
            hintText: "Description",
          ),
        ),
      ]),
    );
  }
}

// class TodosList extends StatefulWidget {
//   TodosList({Key? key}) : super(key: key);

//   @override
//   State<TodosList> createState() => _TodoListState();
// }

// class _TodoListState extends State<TodosList> {
//   @override
//   static var todos = <TodoItem>[];

//   @override
//   void initState() {
//     super.initState();
//     todos.add(
//       TodoItem(title: "1", description: "chto-to"),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Container(
//         child: ListView.builder(
//             itemCount: HomePage.snap,
//             itemBuilder: (BuildContext context, int i) {
//               final todo = todos[i];
//               return Dismissible(
//                 key: UniqueKey(),
//                 onDismissed: (direction) {
//                   setState(() {
//                     todos.removeAt(i);
//                     print(todos.length);
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(todo.title + ' dismissed')));
//                 },
//                 background: Container(
//                   color: Colors.red,
//                   margin: EdgeInsets.symmetric(vertical: 4),
//                 ),
//                 child: Card(
//                   elevation: 2.0,
//                   margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   child: Container(
//                     decoration: BoxDecoration(color: Color(0xFF455A64)),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                       title: Container(
//                         padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
//                         child: Text(
//                           todo.title,
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20),
//                         ),
//                       ),
//                       subtitle: Container(
//                         padding: EdgeInsets.only(left: 20, bottom: 10),
//                         child: Text(todo.description,
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 20)),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//       ),
//     );
//   }
// }
