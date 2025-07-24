class Activity {
  String? title;
  String? content;
  String? imagePath;
  int? type;
  String? created;
  int? status;
  String? uuid;

  Activity(
      {this.title,
      this.content,
      this.imagePath,
      this.type,
      this.created,
      this.status,
      this.uuid});

  Activity.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    imagePath = json['imagePath'];
    type = json['type'];
    created = json['created'];
    status = json['status'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['imagePath'] = this.imagePath;
    data['type'] = this.type;
    data['created'] = this.created;
    data['status'] = this.status;
    data['uuid'] = this.uuid;
    return data;
  }
}
