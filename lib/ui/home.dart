import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:taskito/models/new_task.dart';
import 'package:taskito/routes.dart';
import 'package:taskito/services/fire_storage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // TextEditingController _datePickerController = TextEditingController(text: '');

  static var now = DateTime.now();
  static var formatter = DateFormat.yMMMMd('en_US');
  var todayDate = formatter.format(now);

  List<Task> taskList = [];
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  final List<DayAndDate> _allPages = <DayAndDate>[];
  final List<TasksOfDay> _allTodaysTask = <TasksOfDay>[];
  final List<String> _allDates = <String>[];

  var todaysDate;
  var count = 0;

  TabController _tabController;
  @override
  void initState() {
    setTabsValues();
    _tabController =
        new TabController(initialIndex: count, length: 7, vsync: this);

    print('date>>>>>>>>>>>>>>>>>>>>>>>..');
    // print(todayDate);
    super.initState();
  }

  setTabsValues() {
    // _allDates.clear();
    var monday = 1;
    var value = 0;
    // var now = new DateTime.now();
    //to get recent monday
    while (now.weekday != monday) {
      now = now.subtract(new Duration(days: 1));
      value++; //for getting the index for the initital tab indicator
      this.setState(() {
        count = count + 1;
      });
    }

    print('Recent monday $now');
    // var now = DateTime.now();

    for (var i = 0; i < 7; i++) {
      var day = now.add(Duration(days: i));
      var abrDay = DateFormat.E(); //abbreviated day
      var abrMonth = DateFormat.d();
      var todayDay = abrDay.format(day).toUpperCase();
      var todayDate = abrMonth.format(day);

      var dayAndDate = DayAndDate(
        abrDay: todayDay,
        todayDate: todayDate,
      );

      _allPages.add(dayAndDate);

      var formatter = DateFormat('yyyy-MM-dd');
      var currentDate = formatter.format(day);
      // print("current Date>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(currentDate);
      //add dates in list so for filtering the tasks and regenrating the tabs
      _allDates.add(currentDate);
      var todaysTaks = TasksOfDay(todayDate: currentDate);
      _allTodaysTask.add(todaysTaks);
    }
  }

  void callDatePicker(BuildContext context) async {
    print('inside date picker method');

    todaysDate = await getDate(context);
    print('Date>>>>>>>>>>>>>. ${todaysDate.toString().split(' ')[0]}');
    // setState(() {
    //   todayDate = todaysDate != null ? todaysDate.toString().split(' ')[0] : '';
    // });

    var formatter = DateFormat('yyyy-MM-dd');
    var currentDate = formatter.format(todaysDate);
    var isMatched = false;
    for (var i = 0; i < _allDates.length; i++) {
      // var day= todayDate.difference(_allDates[i]).inDays;
      // var isDayDiff= todaysDate.compareTo(_allDates[i]);

      print('checkDiff Values');
      print('$currentDate check matched  ${_allDates[i]}');
      print(currentDate == _allDates[i]);
      if (currentDate == _allDates[i]) {
        this.setState(() {
          print('inside setState ');
          _allDates.clear();
          now = DateTime.parse(_allDates[i]);
          count = i + 1;
          isMatched = true;
          print('$now >>> $count >>>> $isMatched');
        });
        break;
      }
    }

    // if (isMatched) {
    //   this.setState(() {
    //     // todayDate = tadayDate != null ? tadayDate.toString().split(' ')[0] : '';
    //     now = DateTime(int.parse(todayDate));
    //   });

    //   setTabsValues();
    // }
  }

  Future<DateTime> getDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routes.getRoute(),
      home: Scaffold(
        backgroundColor: Colors.white,
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
                            InkWell(
                              onTap: () async {
                                callDatePicker(context);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      todayDate,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color.fromRGBO(12, 33, 77, 0.5),
                                      ),
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
                  // expandedHeight: 20.0,
                  // **Is it intended ?** flexibleSpace.title overlaps with tabs title.
                  // flexibleSpace: FlexibleSpaceBar(
                  //   title: Text("FlexibleSpace title"),
                  // ),

                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(1.0),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Color.fromRGBO(90, 85, 202, 1.0),
                      indicatorColor: Color.fromRGBO(90, 85, 202, 1.0),
                      tabs: _allPages
                          .map(
                            (p) => Tab(
                              child: p,
                            ),
                          )
                          .toList(),
                    ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          // padding: EdgeInsets.all(1.0),
          // width: MediaQuery.of(context).size.width / 7,
          child: Column(
            children: <Widget>[
              Text(
                abrDay,
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                todayDate,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TasksOfDay extends StatefulWidget {
  final String todayDate;
  TasksOfDay({this.todayDate});

  @override
  _TasksOfDayState createState() => _TasksOfDayState();
}

class _TasksOfDayState extends State<TasksOfDay> {
  shareData(BuildContext context, var data) {
    final RenderBox box = context.findRenderObject();

    Share.share(
      "Tasks Name",
      subject: 'Tasks',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: FutureBuilder(
            future: getAllTasks(widget.todayDate),
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
                      var person =
                          data.personList.length > 1 ? 'Persons' : 'Person';

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10.0,
                              spreadRadius: 3.0,
                              color: Colors.black12,
                              offset: Offset(3.0, 3.0),
                            )
                          ],
                        ),
                        margin: EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 8.0,
                        ),
                        padding: EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 10.0,
                          bottom: 8.0,
                        ),
                        height: 160,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data.categorySelected,
                              style: TextStyle(
                                color: color,
                                fontSize: 14.0,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: color,
                                        width: 3.0,
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
                                          margin: EdgeInsets.only(bottom: 5.0),
                                          child: Text(
                                            data.name,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                  11,
                                                  32,
                                                  76,
                                                  1.0,
                                                ),
                                                fontSize: 18.0,
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
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => PopupMenuButton<int>(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: Text(
                                          "Earth",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: Text(
                                          "Moon",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 3,
                                        child: Text(
                                          "Sun",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                    child: Container(
                                      height: 50,
                                      width: 200,
                                      decoration: ShapeDecoration(
                                        color: Colors.green,
                                        shape: StadiumBorder(
                                          side: BorderSide(
                                              color: Colors.black, width: 2),
                                        ),
                                      ),
                                      child: Icon(Icons.airplanemode_active),
                                    ),
                                  ),
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    child:
                                        Image.asset('assets/images/menu.png'),
                                  ),
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
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'assets/images/clock.png'),
                                      ),
                                      Text(
                                        // '${data.startTime}-${data.endTime}',
                                        '${data.startTime}-${data.endTime}',
                                        style: TextStyle(fontSize: 14.0),
                                      )
                                    ],
                                  ),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(right: 8.0),
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'assets/images/group.png'),
                                      ),
                                      Text(
                                        '${data.personList.length} $person',
                                        style: TextStyle(fontSize: 14.0),
                                      )
                                    ],
                                  ),
                                  Builder(
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                        onTap: () {
                                          shareData(context, data);
                                        },
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 8.0),
                                              height: 20,
                                              width: 20,
                                              child: Image.asset(
                                                  'assets/images/share.png'),
                                            ),
                                            Text(
                                              'Share',
                                              style: TextStyle(fontSize: 14.0),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Color.fromRGBO(90, 85, 202, 1.0),
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
