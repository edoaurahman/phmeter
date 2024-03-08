class TempModel {
  TempModel({
    String? id,
    dynamic ph,
    dynamic temp,
    dynamic ppm,
    String? timestamp,
  }) {
    _id = id;
    _ph = ph;
    _temp = temp;
    _ppm = ppm;
    _timestamp = timestamp;
  }

  TempModel.fromJson(dynamic json) {
    _id = json['id'];
    _ph = json['ph'];
    _temp = json['temp'];
    _ppm = json['ppm'];
    _timestamp = json['timestamp'];
  }
  String? _id;
  String? _ph;
  String? _temp;
  String? _ppm;
  String? _timestamp;
  TempModel copyWith({
    String? id,
    String? ph,
    String? temp,
    String? ppm,
    String? timestamp,
  }) =>
      TempModel(
        id: id ?? _id,
        ph: ph ?? _ph,
        temp: temp ?? _temp,
        ppm: ppm ?? _ppm,
        timestamp: timestamp ?? _timestamp,
      );
  String? get id => _id;
  String? get ph => _ph;
  String? get temp => _temp;
  String? get ppm => _ppm;
  String? get timestamp => _timestamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['ph'] = _ph;
    map['temp'] = _temp;
    map['ppm'] = _ppm;
    map['timestamp'] = _timestamp;
    return map;
  }
}
