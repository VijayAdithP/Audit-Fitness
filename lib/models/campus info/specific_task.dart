// class SpecificTask {
//   int? id;
//   int? weekNumber;
//   String? month;
//   int? year;
//   String? taskId;
//   String? auditDate;
//   String? mainArea;
//   String? specificArea;
//   String? reportObservation;
//   String? specificTaskId;
//   String? actionTaken;
//   String? status;
//   String? updatedAt;

//   SpecificTask(
//       {this.id,
//       this.weekNumber,
//       this.month,
//       this.year,
//       this.taskId,
//       this.auditDate,
//       this.mainArea,
//       this.specificArea,
//       this.reportObservation,
//       this.specificTaskId,
//       this.actionTaken,
//       this.status,
//       this.updatedAt});

//   SpecificTask.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     weekNumber = json['week_number'];
//     month = json['month'];
//     year = json['year'];
//     taskId = json['task_id'];
//     auditDate = json['audit_date'];
//     mainArea = json['main_area'];
//     specificArea = json['specific_area'];
//     reportObservation = json['report_observation'];
//     specificTaskId = json['specific_task_id'];
//     actionTaken = json['action_taken'];
//     status = json['status'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['week_number'] = this.weekNumber;
//     data['month'] = this.month;
//     data['year'] = this.year;
//     data['task_id'] = this.taskId;
//     data['audit_date'] = this.auditDate;
//     data['main_area'] = this.mainArea;
//     data['specific_area'] = this.specificArea;
//     data['report_observation'] = this.reportObservation;
//     data['specific_task_id'] = this.specificTaskId;
//     data['action_taken'] = this.actionTaken;
//     data['status'] = this.status;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

class SpecificTask {
  int? id;
  int? weekNumber;
  String? month;
  int? year;
  String? taskId;
  String? auditDate;
  String? mainArea;
  String? specificArea;
  String? reportObservation;
  String? specificTaskId;
  String? actionTaken;
  String? status;
  String? updatedAt;

  SpecificTask(
      {this.id,
      this.weekNumber,
      this.month,
      this.year,
      this.taskId,
      this.auditDate,
      this.mainArea,
      this.specificArea,
      this.reportObservation,
      this.specificTaskId,
      this.actionTaken,
      this.status,
      this.updatedAt});

  SpecificTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weekNumber = json['week_number'];
    month = json['month'];
    year = json['year'];
    taskId = json['task_id'];
    auditDate = json['audit_date'];
    mainArea = json['main_area'];
    specificArea = json['specific_area'];
    reportObservation = json['report_observation'];
    specificTaskId = json['specific_task_id'];
    actionTaken = json['action_taken'];
    status = json['status'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['week_number'] = this.weekNumber;
    data['month'] = this.month;
    data['year'] = this.year;
    data['task_id'] = this.taskId;
    data['audit_date'] = this.auditDate;
    data['main_area'] = this.mainArea;
    data['specific_area'] = this.specificArea;
    data['report_observation'] = this.reportObservation;
    data['specific_task_id'] = this.specificTaskId;
    data['action_taken'] = this.actionTaken;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
