import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:taskito/models/person_detail.dart';
import 'package:taskito/services/fire_storage.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  @override
  TaskState get initialState => TaskInitial();

  @override
  void onTransition(Transition<TaskEvent, TaskState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<TaskState> mapEventToState(
    TaskEvent event,
  ) async* {
    if (event is FirebaseDataInitialEvent) {
      print('inside firebaseDataInitialEvent');

      List<PersonDetail> personDetailList = await getFirebaseStorageFiles();
      print(personDetailList);
      yield FirebaseDatabaseState(firebaseData: personDetailList);
      
    } else if (event is CategoryEvent) {
      //  await  getFirebaseStorageFiles();
      print("hello arsh " + event.categoryType.toString());
      switch (event.categoryType) {
        case 0:
          print('Category state returned');
          yield CategoryState(urgent: true, running: false, ongoing: false);
          break;

        case 1:
          print('Category state returned');
          yield CategoryState(urgent: false, running: true, ongoing: false);
          break;

        case 2:
          print('Category state returned');
          yield CategoryState(urgent: false, running: false, ongoing: true);
          break;

        default:
          print('Category state returned');
          yield CategoryState(urgent: false, running: true, ongoing: false);
          break;
      }
    }
  }
}
