import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskito/routes.dart';
import 'package:taskito/services/fire_storage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static var now = DateTime.now();
  static var formatter = DateFormat('yyyy-MM-dd');
  var todayDate = formatter.format(now);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routes.getRoute(),
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, contraints) {
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
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
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
                                  'Running',
                                  style: TextStyle(
                                    color: Colors.greenAccent,
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
                                            color: Colors.greenAccent,
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
                                                'Application Design Meeting',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                      11,
                                                      32,
                                                      76,
                                                      1.0,
                                                    ),
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text(
                                              'Website UI Design for \$500',
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
                                            '2Persons',
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
