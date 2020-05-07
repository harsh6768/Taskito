part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();
}

class TaskInitial extends TaskState {
  @override
  List<Object> get props => [];
}

class CategoryState extends TaskState {
  final bool urgent;
  final bool running;
  final bool ongoing;

  CategoryState({this.urgent, this.running, this.ongoing}) {
    print('inside catergoystate');
  }

  @override
  List<Object> get props => [urgent, running, ongoing];
}

class FirebaseDatabaseState extends TaskState{

  final dynamic firebaseData;
  FirebaseDatabaseState({this.firebaseData});

  @override
  List<Object> get props => [firebaseData];

}

class SuccessState extends TaskState {
  @override
  List<Object> get props => null;
}

