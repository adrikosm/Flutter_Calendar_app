import 'package:firebase_database/firebase_database.dart';

class TaskModel {
  dynamic id;
  dynamic userID;
  dynamic title;
  dynamic description;
  dynamic assign;
  dynamic date;
  dynamic startTime;
  dynamic endTime;
  dynamic remind;
  dynamic color;
  dynamic isCompleted;

  TaskModel(
      {this.id,
      this.userID,
      this.title,
      this.description,
      this.assign,
      this.isCompleted,
      this.date,
      this.startTime,
      this.endTime,
      this.remind,
      this.color});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    title = json['title'];
    description = json['description'];
    assign = json['assign'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    remind = json['remind'];
    color = json['color'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userID;
    data['title'] = title;
    data['description'] = description;
    data['assign'] = assign;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['remind'] = remind;
    data['color'] = color;
    data['isCompleted'] = isCompleted;
    return data;
  }

  void setID(DatabaseReference id) {
    this.id = id;
  }
}
