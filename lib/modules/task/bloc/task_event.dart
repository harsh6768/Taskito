part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
}

class FirebaseDataInitialEvent extends TaskEvent {
  FirebaseDataInitialEvent(){
    print('firebase database event called');
  }
  @override
  List<Object> get props => null;
}

class CategoryEvent extends TaskEvent {
  final int categoryType;
  CategoryEvent({this.categoryType});
  @override
  List<Object> get props => [categoryType];
}
