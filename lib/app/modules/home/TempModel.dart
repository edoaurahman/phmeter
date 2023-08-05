class temp_model {
  temp_model({
    num? id,
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

  temp_model.fromJson(dynamic json) {
    _id = json['id'];
    _ph = json['ph'];
    _temp = json['temp'];
    _ppm = json['ppm'];
    _timestamp = json['timestamp'];
  }
  num? _id;
  String? _ph;
  String? _temp;
  String? _ppm;
  String? _timestamp;
  temp_model copyWith({
    num? id,
    String? ph,
    String? temp,
    String? ppm,
    String? timestamp,
  }) =>
      temp_model(
        id: id ?? _id,
        ph: ph ?? _ph,
        temp: temp ?? _temp,
        ppm: ppm ?? _ppm,
        timestamp: timestamp ?? _timestamp,
      );
  num? get id => _id;
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
