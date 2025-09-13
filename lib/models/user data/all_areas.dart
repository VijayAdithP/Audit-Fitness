class AreasUser {
  int? id;
  int? mainAreaId;
  String? areaSpecific;
  String? areaSpecificTamil;

  AreasUser(
      {this.id, this.mainAreaId, this.areaSpecific, this.areaSpecificTamil});

  AreasUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainAreaId = json['main_area_id'];
    areaSpecific = json['area_specific'];
    areaSpecificTamil = json['area_specific_tamil'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['main_area_id'] = this.mainAreaId;
    data['area_specific'] = this.areaSpecific;
    data['area_specific_tamil'] = this.areaSpecificTamil;
    return data;
  }
}

class CombinedData {
  int serialNumber;
  String mainArea;
  String specificArea;
  String reportObservation;
  String remarks;
  List<String> images;

  CombinedData({
    required this.serialNumber,
    required this.mainArea,
    required this.specificArea,
    required this.reportObservation,
    required this.remarks,
    required this.images,
  });
}
