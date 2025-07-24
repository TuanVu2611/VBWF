class DetailAchievement {
  String? title;
  String? content;
  int? sort;
  String? date;
  int? privacy;
  String? created;
  int? status;
  String? filePath;
  String? uuid;

  DetailAchievement(
      {this.title,
      this.content,
      this.sort,
      this.date,
      this.privacy,
      this.created,
      this.status,
      this.filePath,
      this.uuid});

  DetailAchievement.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    sort = json['sort'];
    date = json['date'];
    privacy = json['privacy'];
    created = json['created'];
    status = json['status'];
    filePath = json['filePath'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['sort'] = this.sort;
    data['date'] = this.date;
    data['privacy'] = this.privacy;
    data['created'] = this.created;
    data['status'] = this.status;
    data['filePath'] = this.filePath;
    data['uuid'] = this.uuid;
    return data;
  }
}