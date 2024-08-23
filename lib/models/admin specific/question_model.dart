class QuestionModel {
  int? id;
  int? specificAreaId;
  int? questionNumber;
  String? question;
  String? questionTamil;

  QuestionModel(
      {this.id,
      this.specificAreaId,
      this.questionNumber,
      this.question,
      this.questionTamil});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specificAreaId = json['specific_area_id'];
    questionNumber = json['question_number'];
    question = json['question'];
    questionTamil = json['question_tamil'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['specific_area_id'] = this.specificAreaId;
    data['question_number'] = this.questionNumber;
    data['question'] = this.question;
    data['question_tamil'] = this.questionTamil;
    return data;
  }
}