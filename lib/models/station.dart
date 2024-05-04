
class StationModel{
  String id;
  String stationName;
  String stationAddress;
  String stationPostcode;
  double latitude;
  double longitude;
  double distance;
  bool stationOnline;
  String vendorName;
  String country;
  bool payByApp;
  bool payAtPump;
  String logo;
  bool accessibleToiletNearby;
  int siUnit;

  StationModel(
      this.id,
      this.stationName,
      this.stationAddress,
      this.stationPostcode,
      this.latitude,
      this.longitude,
      this.distance,
      this.stationOnline,
      this.vendorName,
      this.country,
      this.payByApp,
      this.payAtPump,
      this.logo,
      this.accessibleToiletNearby,
      this.siUnit
      );

  StationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        stationName = json['stationName'],
        stationAddress = json['stationAddress'],
        stationPostcode = json['stationPostcode'],
        latitude = json['latitude'] as double,
        longitude = json['longitude'] as double,
        distance = json['distance'] as double,
        stationOnline = json['stationOnline'] as bool,
        vendorName = json['vendorName'],
        country = json['country'],
        payByApp = json['payByApp'] as bool,
        payAtPump = json['payAtPump'] as bool,
        logo = json['logo'],
        accessibleToiletNearby = json['accessibleToiletNearby'] as bool,
        siUnit = json['siUnit'] as int;

  Map<String, dynamic> toJson() {
    // Remove unnecessary 'new' and use a collection literal instead
    //final Map<String, dynamic> data = new Map<String, dynamic>();
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stationName'] = stationName;
    data['stationAddress'] = stationAddress;
    data['stationPostcode'] = stationPostcode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distance'] = distance;
    data['stationOnline'] = stationOnline;
    data['vendorName'] = vendorName;
    data['country'] = country;
    data['payByApp'] = payByApp;
    data['payAtPump'] = payAtPump;
    data['logo'] = logo;
    data['accessibleToiletNearby'] = accessibleToiletNearby;
    data['siUnit'] = siUnit;
    return data;
  }

}