import 'package:intl/intl.dart';

class WeeklyTaskId {
  int? weekTaskId;
  String? weeklyTaskId;
  int? weekNumber;
  String? month;
  int? year;
  String? createdAt;

  WeeklyTaskId(
      {this.weekTaskId,
      this.weeklyTaskId,
      this.weekNumber,
      this.month,
      this.year,
      this.createdAt});

  WeeklyTaskId.fromJson(Map<String, dynamic> json) {
    weekTaskId = json['weekTask_id'];
    weeklyTaskId = json['weekly_taskId'];
    weekNumber = json['weekNumber'];
    month = json['month'];
    year = json['year'];
    createdAt = formatDate(json['created_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weekTask_id'] = this.weekTaskId;
    data['weekly_taskId'] = this.weeklyTaskId;
    data['weekNumber'] = this.weekNumber;
    data['month'] = this.month;
    data['year'] = this.year;
    data['created_at'] = this.createdAt;
    return data;
  }

  String? formatDate(String? dateString) {
    if (dateString == null) return null;
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
