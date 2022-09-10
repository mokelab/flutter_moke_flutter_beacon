class Range {
  final String identifer;
  final String? proximityUUID;
  final int? major;
  final int? minor;

  Range(this.identifer, this.proximityUUID, this.major, this.minor);

  toMap() {
    var map = <String, dynamic>{
      "identifier": identifer,
    };
    if (proximityUUID != null) {
      map["proximityUUID"] = proximityUUID;
    }
    if (major != null) {
      map["major"] = major;
    }
    if (minor != null) {
      map["minor"] = minor;
    }

    return map;
  }

  static Range from(dynamic json) {
    String identifier = json['identifier'];
    String? proximityUUID = json['proximityUUID'];
    int? major = json['major'];
    int? minor = json['minor'];
    return Range(identifier, proximityUUID, major, minor);
  }
}
