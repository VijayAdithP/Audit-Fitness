// // class CampusProgressTable {
// //   String? mainArea;
// //   List<SpecificAreas>? specificAreas;

// //   CampusProgressTable({this.mainArea, this.specificAreas});

// //   CampusProgressTable.fromJson(Map<String, dynamic> json) {
// //     mainArea = json['main_area'];
// //     if (json['specific_areas'] != null) {
// //       specificAreas = <SpecificAreas>[];
// //       json['specific_areas'].forEach((v) {
// //         specificAreas!.add(new SpecificAreas.fromJson(v));
// //       });
// //     }
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['main_area'] = this.mainArea;
// //     if (this.specificAreas != null) {
// //       data['specific_areas'] =
// //           this.specificAreas!.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }

// // class SpecificAreas {
// //   String? specificArea;
// //   List<Audits>? audits;

// //   SpecificAreas({this.specificArea, this.audits});

// //   SpecificAreas.fromJson(Map<String, dynamic> json) {
// //     specificArea = json['specific_area'];
// //     if (json['audits'] != null) {
// //       audits = <Audits>[];
// //       json['audits'].forEach((v) {
// //         audits!.add(new Audits.fromJson(v));
// //       });
// //     }
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['specific_area'] = this.specificArea;
// //     if (this.audits != null) {
// //       data['audits'] = this.audits!.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }

// // class Audits {
// //   int? weekNumber;
// //   String? month;
// //   int? year;
// //   int? taskId;
// //   String? auditDate;
// //   String? reportObservation;
// //   int? specificTaskId;
// //   String? actionTaken;
// //   String? status;

// //   Audits(
// //       {this.weekNumber,
// //       this.month,
// //       this.year,
// //       this.taskId,
// //       this.auditDate,
// //       this.reportObservation,
// //       this.specificTaskId,
// //       this.actionTaken,
// //       this.status});

// //   Audits.fromJson(Map<String, dynamic> json) {
// //     weekNumber = json['week_number'];
// //     month = json['month'];
// //     year = json['year'];
// //     taskId = json['task_id'];
// //     auditDate = json['audit_date'];
// //     reportObservation = json['report_observation'];
// //     specificTaskId = json['specific_task_id'];
// //     actionTaken = json['action_taken'];
// //     status = json['status'];
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['week_number'] = this.weekNumber;
// //     data['month'] = this.month;
// //     data['year'] = this.year;
// //     data['task_id'] = this.taskId;
// //     data['audit_date'] = this.auditDate;
// //     data['report_observation'] = this.reportObservation;
// //     data['specific_task_id'] = this.specificTaskId;
// //     data['action_taken'] = this.actionTaken;
// //     data['status'] = this.status;
// //     return data;
// //   }
// // }

// class CampusProgressTable {
//   String? taskId;
//   String? mainArea;
//   List<SpecificAreas>? specificAreas;

//   CampusProgressTable({this.taskId, this.mainArea, this.specificAreas});

//   CampusProgressTable.fromJson(Map<String, dynamic> json) {
//     taskId = json['task_id'];
//     mainArea = json['main_area'];
//     if (json['specific_areas'] != null) {
//       specificAreas = <SpecificAreas>[];
//       json['specific_areas'].forEach((v) {
//         specificAreas!.add(new SpecificAreas.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['task_id'] = this.taskId;
//     data['main_area'] = this.mainArea;
//     if (this.specificAreas != null) {
//       data['specific_areas'] =
//           this.specificAreas!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class SpecificAreas {
//   String? specificArea;
//   String? auditDate;
//   String? reportObservation;
//   int? specificTaskId;
//   String? actionTaken;
//   String? status;

//   SpecificAreas(
//       {this.specificArea,
//       this.auditDate,
//       this.reportObservation,
//       this.specificTaskId,
//       this.actionTaken,
//       this.status});

//   SpecificAreas.fromJson(Map<String, dynamic> json) {
//     specificArea = json['specific_area'];
//     auditDate = json['audit_date'];
//     reportObservation = json['report_observation'];
//     specificTaskId = json['specific_task_id'];
//     actionTaken = json['action_taken'];
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['specific_area'] = this.specificArea;
//     data['audit_date'] = this.auditDate;
//     data['report_observation'] = this.reportObservation;
//     data['specific_task_id'] = this.specificTaskId;
//     data['action_taken'] = this.actionTaken;
//     data['status'] = this.status;
//     return data;
//   }
// }

class CampusProgressTable {
  String? taskId;
  String? mainArea;
  List<SpecificAreas>? specificAreas;

  CampusProgressTable({this.taskId, this.mainArea, this.specificAreas});

  CampusProgressTable.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    mainArea = json['main_area'];
    if (json['specific_areas'] != null) {
      specificAreas = <SpecificAreas>[];
      json['specific_areas'].forEach((v) {
        specificAreas!.add(new SpecificAreas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_id'] = this.taskId;
    data['main_area'] = this.mainArea;
    if (this.specificAreas != null) {
      data['specific_areas'] =
          this.specificAreas!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  int get totalValidObservationCount {
    int count = 0;
    if (specificAreas != null) {
      for (var area in specificAreas!) {
        count += area.validObservationCount;
      }
    }
    return count;
  }

  int get totalRemarksCount {
    int count = 0;
    if (specificAreas != null) {
      for (var area in specificAreas!) {
        if (area.actionTaken != null && area.actionTaken!.isNotEmpty) {
          count++;
        }
      }
    }
    return count;
  }
}

class SpecificAreas {
  String? specificArea;
  String? auditDate;
  String? reportObservation;
  String? specificTaskId;
  String? actionTaken;
  String? status;

  SpecificAreas(
      {this.specificArea,
      this.auditDate,
      this.reportObservation,
      this.specificTaskId,
      this.actionTaken,
      this.status});

  SpecificAreas.fromJson(Map<String, dynamic> json) {
    specificArea = json['specific_area'];
    auditDate = json['audit_date'];
    reportObservation = json['report_observation'];
    specificTaskId = json['specific_task_id'];
    actionTaken = json['action_taken'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specific_area'] = this.specificArea;
    data['audit_date'] = this.auditDate;
    data['report_observation'] = this.reportObservation;
    data['specific_task_id'] = this.specificTaskId;
    data['action_taken'] = this.actionTaken;
    data['status'] = this.status;
    return data;
  }

  int get validObservationCount {
    if (reportObservation == null || reportObservation!.isEmpty) {
      return 0;
    }
    return reportObservation!
        .split(',')
        .where((observation) => observation.trim().isNotEmpty)
        .length;
  }
}
