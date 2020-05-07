import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => HomeInitial();

  @override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if(event is AddTaskEvent){
      print('hello harsh');
      yield NavigateTaskState();
    }
  }
}
