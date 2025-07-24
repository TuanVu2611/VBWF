class Video {
  String? title;
  String? thumbnail;
  String? videoLink;
  String? created;
  int? status;
  String? uuid;

  Video({this.title, this.videoLink, this.created, this.status, this.uuid});

  Video.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    videoLink = json['videoLink'];
    created = json['created'];
    status = json['status'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['videoLink'] = this.videoLink;
    data['created'] = this.created;
    data['status'] = this.status;
    data['uuid'] = this.uuid;
    return data;
  }
}