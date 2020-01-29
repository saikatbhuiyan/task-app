import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:query_params/query_params.dart';

import 'package:todo_app/global.dart';

class Task {
  int id;
  String name;
  int todoId;
  bool isFinished;
  Task({this.id, this.name, this.todoId, this.isFinished});

  factory Task.fromJson(Map<String, dynamic> json) {
    Task newTask = Task(
        id: json['id'],
        name: json['name'],
        isFinished: json['isFinished'],
        todoId: json['todoId']);
    return newTask;
  }
  // clone a Task, or "copy constructor"
  factory Task.fromTask(Task anotherTask) {
    return Task(
        id: anotherTask.id,
        name: anotherTask.name,
        todoId: anotherTask.todoId,
        isFinished: anotherTask.isFinished);
  }
}

// Controllers = "functions relating to task"
// fetch tasks
Future<List<Task>> fetchTasks(http.Client client, int todoId) async {
  final response =
      await client.get("https://apimytodo.herokuapp.com/api/$todoId/task/");
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    final tasks = mapResponse["results"].cast<Map<String, dynamic>>();
    return tasks.map<Task>((json) {
      return Task.fromJson(json);
    }).toList();
  } else {
    throw Exception('Failed to load Task');
  }
}

// Fetch Task By Id
Future<Task> fetchTaskById(http.Client client, int id) async {
//  final String url = "https://apimytodo.herokuapp.com/api/router/task/$id/";
  final String url = "https://apimytodo.herokuapp.com/api/router/task/$id/";
  final response = await client.get(url);
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    Map<String, dynamic> mapTask = mapResponse;
    return Task.fromJson(mapTask);
  } else {
    throw Exception('Failed to load Task By Id');
  }
}

// Update a task
Future<Task> updateATask(
    http.Client client, Map<String, dynamic> params) async {
  final response = await client.put('$URL_TASKS/${params["id"]}', body: params);
  if (response.statusCode == 200) {
    final responseBody = await json.decode(response.body);
    return Task.fromJson(responseBody);
  } else {
    throw Exception('Failed to update a Task. Error: ${response.toString()}');
  }
}
