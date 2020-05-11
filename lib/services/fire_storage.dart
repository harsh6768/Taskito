import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:taskito/models/new_task.dart';
import 'package:taskito/models/person_detail.dart';

Future<List<PersonDetail>> getFirebaseStorageFiles() async {
  List<PersonDetail> personList = List<PersonDetail>();

  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  var snapshot = await firebaseDatabase.reference().child('persons').once();

  print(snapshot.value);

  for (var snap in snapshot.value) {
    var person = PersonDetail(
        imageUrl: snap['image_url'], name: snap['name'], isSelected: false);
    personList.add(person);
  }
  return personList;
}

Future<bool> addNewTaskFirebase(Task newTask) async {
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference databaseReference = firebaseDatabase.reference();

  await databaseReference.child('tasks').push().set(newTask.toJson());

  return true;
}

Future<List<Task>> getAllTasks() async {

  print("date::::>>>>>>>>>>>>>>");
  // print(date);

  List<Task> taskList = List<Task>();

  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  var snapshot = await firebaseDatabase.reference().child('tasks').once();

  // print(snapshot.value);

  var keys = snapshot.value.keys;
  for (var key in keys) {
    var snap = snapshot.value[key];
    // print('snap values');
    // print(snap);

    var task = Task(
      name: snap['name'],
      date: snap['date'],
      startTime: snap['start_time'],
      endTime: snap['end_time'],
      description: snap['description'],
      categorySelected: snap['category_selected'],
      personList: snap['person_list'],
    );

    // var task=Task.fromJson(jsonEncode(snap));
    // print(task);

    taskList.add(task);
  }
  // taskList = List<Task>.from(
  //   snapshot.value.map(
  //     (snap) {
  //       print('task snap');
  //       print(snap);
  //       // var task=snap[]
  //       return Task.fromJson(snap);
  //     },
  //   ),
  // );
  // print('task List');
  // print(taskList);

  // return personList;
  return Future.value(taskList);
}
