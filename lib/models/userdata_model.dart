class UserDataModel {
  dynamic id;
  dynamic firstName;
  dynamic lastName;
  dynamic email;
  dynamic password;
  dynamic color;
  dynamic startTime;
  dynamic endTime;
  dynamic usertype; // Usertype can be either 'admin' or 'user'
  bool isLoggedIn;

  UserDataModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.color,
      this.startTime,
      this.endTime,
      this.usertype,
      this.isLoggedIn});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    color = json['color'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    usertype = json['usertype'];
    isLoggedIn = json['isLoggedIn'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['password'] = password;
    data['color'] = color;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['usertype'] = usertype;
    data['isLoggedIn'] = isLoggedIn;
    return data;
  }

}
