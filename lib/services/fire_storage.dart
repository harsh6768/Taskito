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
