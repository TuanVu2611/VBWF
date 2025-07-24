class Banner {
  String? uuid;
  String? name;
  String? avatarPath;
  List<String>? banners;

  Banner({this.uuid, this.name, this.avatarPath, this.banners});

  Banner.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    avatarPath = json['avatarPath'];
    banners = json['banners'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['avatarPath'] = this.avatarPath;
    data['banners'] = this.banners;
    return data;
  }
}
