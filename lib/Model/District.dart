class District {
  String? maqh;
  String? name;
  String? type;
  String? matp;

  District({this.maqh, this.name, this.type, this.matp});

  District.fromJson(Map<String, dynamic> json) {
    maqh = json['maqh'];
    name = json['name'];
    type = json['type'];
    matp = json['matp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maqh'] = this.maqh;
    data['name'] = this.name;
    data['type'] = this.type;
    data['matp'] = this.matp;
    return data;
  }
}
