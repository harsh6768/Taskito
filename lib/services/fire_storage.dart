import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:taskito/models/person_detail.dart';

Future<List<PersonDetail>> getFirebaseStorageFiles() async {
  // var storage=FirebaseStorage.instance;
  // // storage.ref().child('persons').getStorage();

  // var val=storage.ref().child('persons').getStorage();
  // print('fireabse data');
  // val.ref().getData(4).then((onValue){

  //  print(onValue);

  // });
  List<PersonDetail> personList = List<PersonDetail>();

  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  var snapshot = await firebaseDatabase.reference().once();

  for (var snap in snapshot.value) {
    // print(snap['image_url']);
    // print(snap['name']);

    var person = PersonDetail(imageUrl: snap['image_url'], name: snap['name']);
    personList.add(person);
  }
  
  // firebaseDatabase.reference().once().then((DataSnapshot snapshot) {
  //   // print(snapshot.value[1]);

  //   for(var snap in snapshot.value){
  //     // print(snap['image_url']);
  //     // print(snap['name']);

  //     var person=PersonDetail(imageUrl: snap['image_url'],name: snap['name']);
  //     personList.add(person);

  //   }

  //   return personList;
  //   // snapshot.value.map((snap)=>print(snap));

  //   // return snapshot.value;
  // });

  return personList;
}
