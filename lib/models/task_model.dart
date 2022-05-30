class TaskModel {
  dynamic id;
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
// PREVIOUS ITERATION
  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
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
}

//   Map<String, Object> toJson() => {
//         TaskFields.id: id ?? 0,
//         TaskFields.title: title,
//         TaskFields.description: description,
//         TaskFields.assign: assign == " " ? "None" : assign,
//         TaskFields.date: date,
//         TaskFields.startTime: startTime,
//         TaskFields.endTime: endTime,
//         TaskFields.remind: remind,
//         TaskFields.color: color,
//         TaskFields.isCompleted: isCompleted ?? 0,
//       };
// }
