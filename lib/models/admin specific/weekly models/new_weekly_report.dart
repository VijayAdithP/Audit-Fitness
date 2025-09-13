// class NewWeeklyReport {
//   String? mainArea;
//   List<SpecificAreas>? specificAreas;

//   NewWeeklyReport({this.mainArea, this.specificAreas});

//   NewWeeklyReport.fromJson(Map<String, dynamic> json) {
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
//   String? remarks;
//   String? images;

//   SpecificAreas(
//       {this.specificArea,
//       this.auditDate,
//       this.reportObservation,
//       this.remarks,
//       this.images});

//   SpecificAreas.fromJson(Map<String, dynamic> json) {
//     specificArea = json['specific_area'];
//     auditDate = json['audit_date'];
//     reportObservation = json['report_observation'];
//     remarks = json['remarks'];
//     images = json['images'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['specific_area'] = this.specificArea;
//     data['audit_date'] = this.auditDate;
//     data['report_observation'] = this.reportObservation;
//     data['remarks'] = this.remarks;
//     data['images'] = this.images;
//     return data;
//   }
// }

class NewWeeklyReport {
  String? mainArea;
  String? taskId;
  List<SpecificAreas>? specificAreas;

  NewWeeklyReport({this.mainArea, this.taskId, this.specificAreas});

  NewWeeklyReport.fromJson(Map<String, dynamic> json) {
    mainArea = json['main_area'];
    taskId = json['task_id'];
    if (json['specific_areas'] != null) {
      specificAreas = <SpecificAreas>[];
      json['specific_areas'].forEach((v) {
        specificAreas!.add(SpecificAreas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['main_area'] = this.mainArea;
    data['task_id'] = this.taskId;
    if (this.specificAreas != null) {
      data['specific_areas'] =
          this.specificAreas!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // Method to calculate the total number of valid observations across all specific areas
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
        if (area.remarks != null && area.remarks!.isNotEmpty) {
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
  String? remarks;
  String? images;

  SpecificAreas(
      {this.specificArea,
      this.auditDate,
      this.reportObservation,
      this.remarks,
      this.images});

  SpecificAreas.fromJson(Map<String, dynamic> json) {
    specificArea = json['specific_area'];
    auditDate = json['audit_date'];
    reportObservation = json['report_observation'];
    remarks = json['remarks'];
    images = json['images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['specific_area'] = this.specificArea;
    data['audit_date'] = this.auditDate;
    data['report_observation'] = this.reportObservation;
    data['remarks'] = this.remarks;
    data['images'] = this.images;
    return data;
  }

  // Method to calculate the number of valid observations for this specific area
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
