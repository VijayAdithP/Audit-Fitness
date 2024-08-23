class SpecificUserMainAreaModel {
  String? mainArea;

  SpecificUserMainAreaModel({this.mainArea});

  SpecificUserMainAreaModel.fromJson(Map<String, dynamic> json) {
    mainArea = json['main_area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_area'] = this.mainArea;
    return data;
  }
}