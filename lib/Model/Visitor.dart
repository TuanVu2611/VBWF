class Visitor {
  Profile? profile;
  String? created;
  String? uuid;

  Visitor({this.profile, this.created, this.uuid});

  Visitor.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    created = json['created'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    data['created'] = this.created;
    data['uuid'] = this.uuid;
    return data;
  }
}

class Profile {
  String? name;
  String? imagePath;
  String? uuid;

  Profile({this.name, this.imagePath, this.uuid});

  Profile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imagePath = json['imagePath'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['imagePath'] = this.imagePath;
    data['uuid'] = this.uuid;
    return data;
  }
}