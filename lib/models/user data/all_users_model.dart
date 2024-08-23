class AllUsersModel {
  int? id;
  String? username;
  String? password;
  int? role;
  String? firstName;
  String? lastName;
  int? phoneNumber;
  String? staffId;
  String? createdAt;

  AllUsersModel(
      {this.id,
      this.username,
      this.password,
      this.role,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.staffId,
      this.createdAt});

  AllUsersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    role = json['role'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    staffId = json['staffId'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['role'] = this.role;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phoneNumber'] = this.phoneNumber;
    data['staffId'] = this.staffId;
    data['created_at'] = this.createdAt;
    return data;
  }
}
