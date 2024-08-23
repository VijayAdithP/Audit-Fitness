class AdminMainAreaModel {
  int? id;
  String? mainArea;

  AdminMainAreaModel({this.id, this.mainArea});

  AdminMainAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainArea = json['main_area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['main_area'] = this.mainArea;
    return data;
  }
}
