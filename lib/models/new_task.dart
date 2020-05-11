import 'package:taskito/models/person_detail.dart';
class Task {
  
  String name;
  List<dynamic> personList;
  String date;
  String startTime;
  String endTime;
  String description;
  String categorySelected;

  Task(
      {this.name,
      this.personList,
      this.date,
      this.startTime,
      this.endTime,
      this.description,
      this.categorySelected});

  Task.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    if (json['person_list'] != null) {
      personList =  List<PersonDetail>();
      json['person_list'].forEach((v) {
        personList.add( PersonDetail.fromJson(v));
      });
    }
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    description = json['description'];
    categorySelected = json['category_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.personList != null) {
      data['person_list'] = this.personList.map((v) => v.toJson()).toList();
    }
    data['date'] = this.date;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['description'] = this.description;
    data['category_selected'] = this.categorySelected;
    return data;
  }
}