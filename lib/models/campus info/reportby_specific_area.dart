class ReportbySpecificArea {
  String? mainArea;
  String? specificArea;
  String? taskId;
  String? auditDate;
  int? weekNumber;
  String? month;
  int? year;
  String? auditorName;
  String? auditorPhone;
  String? suggestions;
  List<AuditData>? auditData;

  ReportbySpecificArea(
      {this.mainArea,
      this.specificArea,
      this.taskId,
      this.auditDate,
      this.weekNumber,
      this.month,
      this.year,
      this.auditorName,
      this.auditorPhone,
      this.suggestions,
      this.auditData});

  ReportbySpecificArea.fromJson(Map<String, dynamic> json) {
    mainArea = json['main_area'];
    specificArea = json['specific_area'];
    taskId = json['task_id'];
    auditDate = json['audit_date'];
    weekNumber = json['week_number'];
    month = json['month'];
    year = json['year'];
    auditorName = json['auditor_name'];
    auditorPhone = json['auditor_phone'];
    suggestions = json['suggestions'];
    if (json['audit_data'] != null) {
      auditData = <AuditData>[];
      json['audit_data'].forEach((v) {
        auditData!.add(new AuditData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_area'] = this.mainArea;
    data['specific_area'] = this.specificArea;
    data['task_id'] = this.taskId;
    data['audit_date'] = this.auditDate;
    data['week_number'] = this.weekNumber;
    data['month'] = this.month;
    data['year'] = this.year;
    data['auditor_name'] = this.auditorName;
    data['auditor_phone'] = this.auditorPhone;
    data['suggestions'] = this.suggestions;
    if (this.auditData != null) {
      data['audit_data'] = this.auditData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AuditData {
  int? questionNumber;
  String? question;
  String? remark;
  String? imagePath;
  String? comment;

  AuditData(
      {this.questionNumber,
      this.question,
      this.remark,
      this.imagePath,
      this.comment});

  AuditData.fromJson(Map<String, dynamic> json) {
    questionNumber = json['question_number'];
    question = json['question'];
    remark = json['remark'];
    imagePath = json['image_path'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_number'] = this.questionNumber;
    data['question'] = this.question;
    data['remark'] = this.remark;
    data['image_path'] = this.imagePath;
    data['comment'] = this.comment;
    return data;
  }
}
