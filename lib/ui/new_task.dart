import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskito/models/new_task.dart';
import 'package:taskito/models/person_detail.dart';
import 'package:taskito/services/fire_storage.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  TextEditingController _datePickerController = TextEditingController(text: '');
  TextEditingController _startTimePickerController =
      TextEditingController(text: '');
  TextEditingController _endTimePickerController =
      TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');

  TextEditingController _taskNameController = TextEditingController(text: '');

  bool isUrgent = false;
  bool isRunning = true;
  bool isOngoing = false;
  TimeOfDay startTimeOfDay;
  TimeOfDay endTimeOfDay;
  var tadaysDate;
  static var now = DateTime.now();
  static var formatter = DateFormat.yMMMMd('en_US');
  var hintDate = formatter.format(now);

  void callStartTimePicker() async {
    startTimeOfDay = await getStartTime();
    setState(() {
      _startTimePickerController.text =
          startTimeOfDay != null ? startTimeOfDay.format(context) : '';
    });
    print('>>>>>>>>>>>>>>>> ${startTimeOfDay.format(context)}');
  }

  Future<TimeOfDay> getStartTime() async {
    final TimeOfDay timeOfDay = await showTimePicker(
      // builder: (BuildContext context, Widget child) {
      //   return MediaQuery(
      //     data: MediaQuery.of(context).copyWith(
      //       alwaysUse24HourFormat: true,
      //     ),
      //     child: child,
      //   );
      // },
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return timeOfDay;
  }

  void callEndTimePicker() async {
    endTimeOfDay = await getEndTime();
    setState(() {
      _endTimePickerController.text =
          endTimeOfDay != null ? endTimeOfDay.format(context) : '';
    });
    print('>>>>>>>>>>>>>>>> ${endTimeOfDay.format(context)}');
  }

  Future<TimeOfDay> getEndTime() async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return timeOfDay;
  }

  void callDatePicker() async {
    tadaysDate = await getDate();
    print('Date>>>>>>>>>>>>>. ${tadaysDate.toString().split(' ')[0]}');
    setState(() {
      _datePickerController.text =
          tadaysDate != null ? tadaysDate.toString().split(' ')[0] : '';
    });
  }

  Future<DateTime> getDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime(2030),
    );
  }

  List<PersonDetail> personDetailList = List<PersonDetail>();

  @override
  void initState() {
    super.initState();

    getPersonData();
  }

  getPersonData() async {
    var personDataList = await getFirebaseStorageFiles();
    print(personDataList);
    this.setState(() async {
      print(personDataList);
      personDetailList.addAll(personDataList);
    });
  }

  onCategorySelect(int categorySelected) {
    switch (categorySelected) {
      case 0:
        {
          this.setState(() {
            isUrgent = true;
            isRunning = false;
            isOngoing = false;
          });
          break;
        }
      case 1:
        {
          this.setState(() {
            isUrgent = false;
            isRunning = true;
            isOngoing = false;
          });
          break;
        }
      case 2:
        {
          this.setState(() {
            isUrgent = false;
            isRunning = false;
            isOngoing = true;
          });
          break;
        }
      default:
        {
          this.setState(() {
            isUrgent = false;
            isRunning = true;
            isOngoing = false;
          });
          break;
        }
    }
  }

  addTaskToFirebase(BuildContext context) async {
    // CircularProgressIndicator();
    String taskName = _taskNameController.value.text;
    String description = _descriptionController.value.text;
    String todaysDate = tadaysDate.toString();
    String startTime = startTimeOfDay.format(context).toString();
    String endTime = endTimeOfDay.format(context).toString();
    print('>>>>>> $startTimeOfDay $endTimeOfDay');


    List<PersonDetail> personDetails = List<PersonDetail>();
    //to get the selected person for the project
    for (var person in personDetailList) {
      if (person.isSelected) {
        personDetails.add(person);
      }
    }

    var selectedCategory =
        isUrgent ? "URGENT" : isRunning ? "RUNNING" : "ONGOING";

    var newTask = Task(
      name: taskName,
      personList: personDetails,
      date: todaysDate,
      startTime: startTime,
      endTime: endTime,
      description: description,
      categorySelected: selectedCategory,
    );

    bool isInserted = await addNewTaskFirebase(newTask);
    if (isInserted) {
      displayDialog();
    }
    print('data inserted successfully');
  }

  void displayDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: Text("Message"),
        content: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: new Text("Data Inserted Successfully!")),
        actions: [
          CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              isDefaultAction: true,
              child: new Text("Close"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    color: Color.fromRGBO(90, 85, 202, 1.0),
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.only(left: 16, right: 16.0, top: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
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
                            top: 30.0,
                            left: 16,
                            right: 16.0,
                          ),
                          child: Text(
                            'Add Task',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3.2,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 30.0),
                        Container(
                          margin: EdgeInsets.only(left: 16.0),
                          padding: EdgeInsets.only(left: 8.0),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color.fromRGBO(90, 85, 202, 1.0),
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: TextField(
                            style: TextStyle(
                              color: Color.fromRGBO(90, 85, 202, 1.0),
                            ),
                            controller: _taskNameController,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Your Task Name',
                              hintStyle: TextStyle(
                                fontSize: 16.0,
                                color: Color.fromRGBO(90, 85, 202, 0.5),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 20.0,
                          ),
                          child: Text(
                            'RECENT MEET',
                            style: TextStyle(
                              fontSize: 14.0,
                              // fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(90, 85, 202, 0.5),
                            ),
                          ),
                        ),
                        FutureBuilder(
                          future: getFirebaseStorageFiles(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                height: 80.0,
                                margin: EdgeInsets.only(left: 16.0),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        this.setState(() {
                                          personDetailList[index].isSelected =
                                              !personDetailList[index]
                                                  .isSelected;
                                        });
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              // color: personDetailList[index]
                                              //       .isSelected
                                              //   ? Color.fromRGBO(
                                              //       90, 85, 202, 0.7)
                                              //   : Colors.white10,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            height: 80,
                                            width: 60,
                                            padding: EdgeInsets.only(
                                              top: 4,
                                            ),
                                            margin: EdgeInsets.only(
                                              // left: 4.0,
                                              right: 8.0,
                                              top: 8,
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          243, 231, 253, 1.0),
                                                  radius: 25.0,
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    child: Image.network(
                                                        personDetailList[index]
                                                            .imageUrl),
                                                  ),
                                                ),
                                                Text(
                                                  personDetailList[index].name,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Color.fromRGBO(
                                                        192, 199, 213, 1.0),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: personDetailList[index]
                                                      .isSelected
                                                  ? Color.fromRGBO(
                                                      90, 85, 202, 0.7)
                                                  : Colors.white10,
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              boxShadow: personDetailList[index]
                                                      .isSelected
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(
                                                          0,
                                                          3,
                                                        ), // changes position of shadow
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                            height: 80,
                                            width: 60,
                                            padding: EdgeInsets.only(
                                              top: 4,
                                            ),
                                            margin: EdgeInsets.only(
                                              // left: 4.0,
                                              right: 8.0,
                                              top: 8,
                                            ),
                                            child: personDetailList[index]
                                                    .isSelected
                                                ? Center(
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 10.0,
                                                  ),
                                          ),
                                          Container(
                                            // foregroundDecoration: BoxDecoration(
                                            //   color: personDetailList[index]
                                            //           .isSelected
                                            //       ? Color.fromRGBO(
                                            //           90, 85, 202, 0.7)
                                            //       : Colors.white10,
                                            //   borderRadius:
                                            //       BorderRadius.circular(16.0),
                                            // ),
                                            height: 80,
                                            width: 60,
                                            padding: EdgeInsets.only(
                                              top: 4,
                                            ),
                                            margin: EdgeInsets.only(
                                              // left: 4.0,
                                              right: 8.0,
                                              top: 8,
                                            ),
                                            child: personDetailList[index]
                                                    .isSelected
                                                ? Center(
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 10.0,
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
                                child: CircularProgressIndicator(
                                  backgroundColor:
                                      Color.fromRGBO(90, 85, 202, 0.5),
                                ),
                              );
                            }
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 20.0,
                          ),
                          child: Text(
                            'DATE',
                            style: TextStyle(
                              fontSize: 14.0,
                              // fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(90, 85, 202, 0.5),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: TextField(
                            style: TextStyle(
                              color: Color.fromRGBO(90, 85, 202, 1.0),
                            ),
                            controller: _datePickerController,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  callDatePicker();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top: 4,
                                  ),
                                  child: Image.asset(
                                    'assets/images/calendar.png',
                                    height: 16,
                                    width: 16,
                                  ),
                                ),
                              ),
                              hintText: hintDate,
                              hintStyle: TextStyle(
                                fontSize: 16.0,
                                color: Color.fromRGBO(90, 85, 202, 1.0),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      top: 20.0,
                                    ),
                                    child: Text(
                                      'START TIME',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        // fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(90, 85, 202, 0.5),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 16, right: 16),
                                    child: TextField(
                                      style: TextStyle(
                                        color: Color.fromRGBO(90, 85, 202, 1.0),
                                      ),
                                      controller: _startTimePickerController,
                                      // cursorColor: AppColors.primaryRed,
                                      decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            callStartTimePicker();
                                          },
                                          child: Image.asset(
                                            'assets/images/less.png',
                                            height: 16,
                                            width: 16,
                                          ),
                                        ),
                                        hintText: '10.00AM',
                                        hintStyle: TextStyle(
                                          fontSize: 16.0,
                                          color:
                                              Color.fromRGBO(90, 85, 202, 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      top: 20.0,
                                    ),
                                    child: Text(
                                      'END TIME',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        // fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(90, 85, 202, 0.5),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 16, right: 16),
                                    child: TextField(
                                      style: TextStyle(
                                        color: Color.fromRGBO(90, 85, 202, 1.0),
                                      ),
                                      controller: _endTimePickerController,
                                      // cursorColor: AppColors.primaryRed,
                                      decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            callEndTimePicker();
                                          },
                                          child: Image.asset(
                                            'assets/images/less.png',
                                            height: 16,
                                            width: 16,
                                          ),
                                        ),
                                        hintText: '11.00AM',
                                        hintStyle: TextStyle(
                                          fontSize: 16.0,
                                          color:
                                              Color.fromRGBO(90, 85, 202, 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 20.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'DESCRIPTION',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  // fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(90, 85, 202, 0.5),
                                ),
                              ),
                              TextField(
                                style: TextStyle(
                                  color: Color.fromRGBO(90, 85, 202, 1.0),
                                ),
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  hintText: "description",
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    color: Color.fromRGBO(90, 85, 202, 0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 20.0,
                          ),
                          child: Text(
                            'CATEGORY',
                            style: TextStyle(
                              fontSize: 14.0,
                              // fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(90, 85, 202, 0.5),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  MaterialButton(
                                    color: isUrgent
                                        ? Color.fromRGBO(255, 102, 0, 0.7)
                                        : Color.fromRGBO(240, 211, 212, 1.0),
                                    child: Text(
                                      'URGENT',
                                      style: TextStyle(
                                        color: isUrgent
                                            ? Colors.white
                                            : Color.fromRGBO(
                                                241, 142, 127, 1.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      print('category method called');
                                      onCategorySelect(0);
                                    },
                                  ),
                                  isUrgent
                                      ? Positioned(
                                          right: 1.0,
                                          top: 4.0,
                                          child: CircleAvatar(
                                            backgroundColor: Color.fromRGBO(
                                                255, 102, 0, 1.0),
                                            radius: 10.0,
                                            child: IconButton(
                                              padding: EdgeInsets.all(3.0),
                                              onPressed: () {},
                                              iconSize: 15.0,
                                              icon: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 10.0,
                                        ),
                                ],
                              ),
                              Stack(
                                children: <Widget>[
                                  MaterialButton(
                                    color: isRunning
                                        ? Color.fromRGBO(44, 192, 156, 1.0)
                                        : Color.fromRGBO(179, 230, 204, 1.0),
                                    // disabledColor: Color.fromRGBO(240, 211, 212, 1.0),
                                    child: Text(
                                      'RUNNING',
                                      style: TextStyle(
                                        color: isRunning
                                            ? Colors.white
                                            : Color.fromRGBO(
                                                102, 204, 153, 1.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      print('category method called');
                                      onCategorySelect(1);
                                    },
                                  ),
                                  isRunning
                                      ? Positioned(
                                          right: 1.0,
                                          top: 4.0,
                                          child: CircleAvatar(
                                            backgroundColor: Color.fromRGBO(
                                                44, 192, 156, 1.0),
                                            radius: 10.0,
                                            child: IconButton(
                                              padding: EdgeInsets.all(3.0),
                                              onPressed: () {},
                                              iconSize: 15.0,
                                              icon: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 10.0,
                                        ),
                                ],
                              ),
                              Stack(
                                children: <Widget>[
                                  MaterialButton(
                                    color: isOngoing
                                        ? Color.fromRGBO(90, 85, 202, 1.0)
                                        : Color.fromRGBO(225, 228, 248, 1.0),
                                    child: Text(
                                      'ONGOING',
                                      style: TextStyle(
                                        color: isOngoing
                                            ? Colors.white
                                            : Color.fromRGBO(
                                                132, 130, 216, 1.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      print('category method called');
                                      onCategorySelect(2);
                                    },
                                  ),
                                  isOngoing
                                      ? Positioned(
                                          right: 1.0,
                                          top: 4.0,
                                          child: CircleAvatar(
                                            backgroundColor: Color.fromRGBO(
                                                90, 85, 202, 1.0),
                                            radius: 10.0,
                                            child: IconButton(
                                              padding: EdgeInsets.all(3.0),
                                              onPressed: () {},
                                              iconSize: 15.0,
                                              icon: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 10.0,
                                        ),
                                ],
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            addTaskToFirebase(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              top: 10.0,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(90, 85, 202, 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                'Create New Task',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
