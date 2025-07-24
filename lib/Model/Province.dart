class Province {
  String? matp;
  String? name;
  String? type;
  String? slug;

  Province({this.matp, this.name, this.type, this.slug});

  Province.fromJson(Map<String, dynamic> json) {
    matp = json['matp'];
    name = json['name'];
    type = json['type'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matp'] = this.matp;
    data['name'] = this.name;
    data['type'] = this.type;
    data['slug'] = this.slug;
    return data;
  }
}
