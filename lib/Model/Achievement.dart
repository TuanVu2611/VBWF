class Achievement {
  String? title;
  String? content;
  int? privacy;
  String? date;
  int? status;
  String? uuid;

  Achievement(
      {this.title,
      this.content,
      this.privacy,
      this.date,
      this.status,
      this.uuid});

  Achievement.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    privacy = json['privacy'];
    date = json['date'];
    status = json['status'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['privacy'] = this.privacy;
    data['date'] = this.date;
    data['status'] = this.status;
    data['uuid'] = this.uuid;
    return data;
  }
}