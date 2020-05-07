import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskito/modules/home/bloc/home_bloc.dart';
import 'package:taskito/modules/task/bloc/task_bloc.dart';
import 'package:taskito/routes.dart';
import 'package:taskito/ui/new_task.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static var now = DateTime.now();
  static var formatter = DateFormat('yyyy-MM-dd');
  var todayDate = formatter.format(now);

  addTask() {
    print('inside addtask');
    HomeBloc().add(AddTaskEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routes.getRoute(),
      home: Scaffold(
          body: BlocListener(
        bloc: HomeBloc(),
        listener: (BuildContext context, HomeState state) {
          // if (state is NavigateTaskState) {
          //   print('inside userListSate to navigate');
          //   // Navigator.of(context).pushNamed('/add_task');
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => BlocProvider<TaskBloc>(
          //         create: (context) => TaskBloc()..add(FirebaseDataInitialEvent()),
          //         child: NewTask(),
          //       ),
          //     ),
          //   );
          // }
        },
        child: BlocBuilder(
          bloc: HomeBloc(),
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16.0, top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.arrow_back_ios,
                              color: Color.fromRGBO(12, 33, 77, 1.0),
                            ),
                            Text(
                              'Task',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(12, 33, 77, 1.0),
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(243, 231, 253, 1.0),
                          radius: 25.0,
                          child: Image.asset(
                            'assets/images/p1.png',
                            height: 35,
                            width: 35,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'May 01,2020',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color.fromRGBO(12, 33, 77, 0.5),
                              ),
                            ),
                            Text(
                              'Today',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(12, 33, 77, 1.0),
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            print('insdie ontap method');
                            // addTask();
                            // Navigator.of(context).pushNamed('/add_task');
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider<TaskBloc>(
                                  create: (BuildContext context) => TaskBloc()
                                    ..add(FirebaseDataInitialEvent()),
                                  child: NewTask(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(242, 105, 80, 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Add Task',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      )),
    );
  }
}
