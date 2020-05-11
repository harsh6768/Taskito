import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskito/models/new_task.dart';
import 'package:taskito/routes.dart';
import 'package:taskito/services/fire_storage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  static var now = DateTime.now();
  static var formatter = DateFormat.yMMMMd('en_US');
  var todayDate = formatter.format(now);

  List<Task> taskList = [];
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  final List<DayAndDate> _allPages = <DayAndDate>[];
  final List<TasksOfDay> _allTodaysTask = <TasksOfDay>[];

  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 7, vsync: this);

    setTabsValues();
    print('date>>>>>>>>>>>>>>>>>>>>>>>..');
    // print(todayDate);
    super.initState();
  }

  setTabsValues() {
    var now = DateTime.now();

    for (var i = 0; i < 7; i++) {
      var day = now.add(Duration(days: i));
      var abrDay = DateFormat.E();
      var abrMonth = DateFormat.d();
      var todayDay = abrDay.format(day).toUpperCase();
      var todayDate = abrMonth.format(day);

      var dayAndDate = DayAndDate(
        abrDay: todayDay,
        todayDate: todayDate,
      );

      _allPages.add(dayAndDate);

      var todaysTaks = TasksOfDay();
      _allTodaysTask.add(todaysTaks);

      print(todayDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routes.getRoute(),
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, contraints) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.only(left: 16, right: 16.0, top: 40.0),
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
                              backgroundColor:
                                  Color.fromRGBO(243, 231, 253, 1.0),
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
                              onTap: () {
                                print('insdie ontap method');
                                Navigator.of(context).pushNamed('/add_task');
                              },
                              child: Container(
                                padding: EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(242, 105, 80, 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
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
                      ),
                    ],
                  ),
                ),
                SliverAppBar(
                  backgroundColor: Colors.white,
                  snap: true,
                  floating: true,
                  // expandedHeight: 80.0,
                  // **Is it intended ?** flexibleSpace.title overlaps with tabs title.
                  // flexibleSpace: FlexibleSpaceBar(
                  //   title: Text("FlexibleSpace title"),
                  // ),

                  bottom: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.red,
                    indicatorColor: Colors.blue,
                    tabs: _allPages
                        .map(
                          (p) => Tab(
                            child: p,
                          ),
                        )
                        .toList(),
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: _allTodaysTask
                        .map(
                          (p) => p,
                        )
                        .toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DayAndDate extends StatelessWidget {
  final String abrDay;
  final String todayDate;
  DayAndDate({this.abrDay, this.todayDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(abrDay, style: TextStyle(fontSize: 14)),
        Text(todayDate, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}

class TasksOfDay extends StatefulWidget {
  @override
  _TasksOfDayState createState() => _TasksOfDayState();
}

class _TasksOfDayState extends State<TasksOfDay> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: getAllTasks(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data[index];
                      var color = data.categorySelected == 'URGENT'
                          ? Color.fromRGBO(255, 102, 0, 0.7)
                          : data.categorySelected == 'RUNNING'
                              ? Color.fromRGBO(44, 192, 156, 1.0)
                              : Color.fromRGBO(90, 85, 202, 1.0);
                      print('snapshot data');
                      print(data);
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 4,
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 8.0,
                            right: 4.0,
                            top: 8.0,
                          ),
                          height: 160,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data.categorySelected,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  right: 8.0,
                                ),
                                height: 1.0,
                                color: Color.fromRGBO(238, 240, 242, 1.0),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: color,
                                          width: 4.0,
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin:
                                                EdgeInsets.only(bottom: 5.0),
                                            child: Text(
                                              data.name,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                    11,
                                                    32,
                                                    76,
                                                    1.0,
                                                  ),
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            data.description,
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                201,
                                                206,
                                                217,
                                                1.0,
                                              ),
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 25,
                                    width: 25,
                                    child:
                                        Image.asset('assets/images/menu.png'),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(right: 8.0),
                                          height: 25,
                                          width: 25,
                                          child: Image.asset(
                                              'assets/images/clock.png'),
                                        ),
                                        Text(
                                          '10-11AM',
                                          style: TextStyle(fontSize: 16.0),
                                        )
                                      ],
                                    ),
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(right: 8.0),
                                          height: 25,
                                          width: 25,
                                          child: Image.asset(
                                              'assets/images/group.png'),
                                        ),
                                        Text(
                                          '${data.personList.length} Persons',
                                          style: TextStyle(fontSize: 16.0),
                                        )
                                      ],
                                    ),
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(right: 8.0),
                                          height: 25,
                                          width: 25,
                                          child: Image.asset(
                                              'assets/images/share.png'),
                                        ),
                                        Text(
                                          'Share',
                                          style: TextStyle(fontSize: 16.0),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  height: 100.0,
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
