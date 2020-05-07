import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskito/models/person_detail.dart';
import 'package:taskito/modules/task/bloc/task_bloc.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  TextEditingController _datePickerController = TextEditingController(text: '');
  TextEditingController _timePickerController = TextEditingController(text: '');

  void callTimePicker() async {
    var timeOfDay = await getTime();
    setState(() {
      _timePickerController.text =
          timeOfDay != null ? timeOfDay.format(context) : '';
    });
    print('>>>>>>>>>>>>>>>> ${timeOfDay.format(context)}');
  }

  Future<TimeOfDay> getTime() async {
    final TimeOfDay timeOfDay = await showTimePicker(
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child,
        );
      },
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return timeOfDay;
  }

  void callDatePicker() async {
    var order = await getDate();
    print('Date>>>>>>>>>>>>>. ${order.toString().split(' ')[0]}');
    setState(() {
      _datePickerController.text =
          order != null ? order.toString().split(' ')[0] : '';
    });
  }

  Future<DateTime> getDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      // builder: (BuildContext context, Widget child) {
      //   return Theme(
      //     data: ThemeData(
      //         textTheme: TextTheme(title: TextStyle(color: AppColors.white))),
      //     child: child,
      //   );
      // },
    );
  }

  categorySelected(int category) {
    TaskBloc().add(CategoryEvent(categoryType: category));
  }

  List<PersonDetail> personDetailList = List<PersonDetail>();

  @override
  void initState() {
    super.initState();

    BlocProvider.of<TaskBloc>(context).listen((state) {
      if (state is FirebaseDatabaseState) {
        // print('valuedkff of firebase');
        // print(state.firebaseData);
        personDetailList.addAll(state.firebaseData);
        // print('personList');
        print(personDetailList);
      }
    });
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
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Your Task Name',
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
                        Container(
                          height: 80.0,
                          margin: EdgeInsets.only(left: 16.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: personDetailList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 80,
                                width: 60,
                                margin: EdgeInsets.only(
                                  // left: 4.0,
                                  right: 4.0,
                                  top: 8,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor:
                                          Color.fromRGBO(243, 231, 253, 1.0),
                                      radius: 25.0,
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: Image.network(
                                            personDetailList[index].imageUrl),
                                      ),
                                    ),
                                    Text(
                                      personDetailList[index].name,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color:
                                            Color.fromRGBO(192, 199, 213, 1.0),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
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
                              hintText: 'May 01,2020',
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
                                      controller: _timePickerController,
                                      // cursorColor: AppColors.primaryRed,
                                      decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            callTimePicker();
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
                                      controller: _timePickerController,
                                      // cursorColor: AppColors.primaryRed,
                                      decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            callTimePicker();
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
                              TextField(),
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
                        BlocBuilder<TaskBloc, TaskState>(
                          bloc: TaskBloc(),
                          builder: (BuildContext context, TaskState state) {
                            print('inside bloc builder');

                            if (state is CategoryState) {
                              print('inside taskBloc');

                              print(
                                  '${state.urgent} ${state.running} ${state.ongoing}');

                              return Container(
                                margin:
                                    EdgeInsets.only(left: 16.0, right: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    MaterialButton(
                                      color: state.urgent
                                          ? Color.fromRGBO(255, 140, 26, 1.0)
                                          : Color.fromRGBO(240, 211, 212, 1.0),
                                      child: Text(
                                        'URGENT',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              241, 142, 127, 1.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        print('category method called');
                                        await categorySelected(0);
                                      },
                                    ),
                                    MaterialButton(
                                      color: state.running
                                          ? Color.fromRGBO(153, 255, 153, 1.0)
                                          : Color.fromRGBO(44, 192, 156, 1.0),
                                      // disabledColor: Color.fromRGBO(240, 211, 212, 1.0),
                                      child: Text('RUNNING'),
                                      onPressed: () async {
                                        print('category method called');
                                        await categorySelected(1);
                                      },
                                    ),
                                    MaterialButton(
                                      color: state.ongoing
                                          ? Color.fromRGBO(225, 228, 248, 1.0)
                                          : Color.fromRGBO(0, 0, 255, 1.0),
                                      child: Text(
                                        'ONGOING',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              132, 130, 216, 1.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        print('category method called');
                                        await categorySelected(2);
                                      },
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return Container(
                                margin:
                                    EdgeInsets.only(left: 16.0, right: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    MaterialButton(
                                      color: Color.fromRGBO(240, 211, 212, 1.0),
                                      child: Text(
                                        'URGENT',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              241, 142, 127, 1.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await categorySelected(0);
                                      },
                                    ),
                                    MaterialButton(
                                      color: Color.fromRGBO(44, 192, 156, 1.0),
                                      // disabledColor: Color.fromRGBO(240, 211, 212, 1.0),
                                      child: Text(
                                        'RUNNING',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        await categorySelected(1);
                                      },
                                    ),
                                    MaterialButton(
                                      color: Color.fromRGBO(225, 228, 248, 1.0),
                                      child: Text(
                                        'ONGOING',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              132, 130, 216, 1.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await categorySelected(2);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        Container(
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

class CustomRadio extends StatefulWidget {
  @override
  createState() {
    return new CustomRadioState();
  }
}

class CustomRadioState extends State<CustomRadio> {
  List<RadioModel> sampleData = new List<RadioModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData.add(new RadioModel(false, 'A', 'April 18'));
    sampleData.add(new RadioModel(false, 'B', 'April 17'));
    sampleData.add(new RadioModel(false, 'C', 'April 16'));
    sampleData.add(new RadioModel(false, 'D', 'April 15'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListItem"),
      ),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sampleData.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            //highlightColor: Colors.red,
            splashColor: Colors.blueAccent,
            onTap: () {
              setState(() {
                sampleData.forEach((element) => element.isSelected = false);
                sampleData[index].isSelected = true;
              });
            },
            child: new RadioItem(sampleData[index]),
          );
        },
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 50.0,
            width: 50.0,
            child: new Center(
              child: new Text(_item.buttonText,
                  style: new TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(left: 10.0),
            child: new Text(_item.text),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}
