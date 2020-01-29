import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Todo {
  Todo({this.id, this.body, this.duedate, this.title});

  int id;
  String title;
  String duedate;
  String body;

  // this is a static method
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        id: json['id'],
        title: json['title'],
        duedate: json['duedate'],
        body: json['body']);
  }
}

// Fetch data from Restful API
Future<List<Todo>> fetchTodos(http.Client client) async {
  //How to make these URLs in a .dart file ?
  final response =
      await client.get("https://apimytodo.herokuapp.com/api/router/todo/");
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);

    final todos = mapResponse["results"].cast<Map<String, dynamic>>();

    final listOfTodos = await todos.map<Todo>((json) {
      return Todo.fromJson(json);
    }).toList();
    return listOfTodos;
  } else {
    throw Exception('Failed to load todo!');
  }
}
