class Town {
  String? xaid;
  String? name;
  String? type;
  String? maqh;

  Town({this.xaid, this.name, this.type, this.maqh});

  Town.fromJson(Map<String, dynamic> json) {
    xaid = json['xaid'];
    name = json['name'];
    type = json['type'];
    maqh = json['maqh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['xaid'] = this.xaid;
    data['name'] = this.name;
    data['type'] = this.type;
    data['maqh'] = this.maqh;
    return data;
  }
}
