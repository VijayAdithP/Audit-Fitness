class UserWeeklyTasksModel {
  int? id;
  String? username;
  String? weeklyTaskId;
  int? weekNumber;
  String? month;
  int? year;
  String? selectedArea;
  String? assignedAt;

  UserWeeklyTasksModel(
      {this.id,
      this.username,
      this.weeklyTaskId,
      this.weekNumber,
      this.month,
      this.year,
      this.selectedArea,
      this.assignedAt});

  UserWeeklyTasksModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    weeklyTaskId = json['weekly_taskId'];
    weekNumber = json['week_number'];
    month = json['month'];
    year = json['year'];
    selectedArea = json['selected_area'];
    assignedAt = json['assigned_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['weekly_taskId'] = this.weeklyTaskId;
    data['week_number'] = this.weekNumber;
    data['month'] = this.month;
    data['year'] = this.year;
    data['selected_area'] = this.selectedArea;
    data['assigned_at'] = this.assignedAt;
    return data;
  }
}
