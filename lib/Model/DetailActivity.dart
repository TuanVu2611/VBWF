class DetailActivity {
  String? title;
  String? content;
  String? link;
  String? fromDate;
  String? toDate;
  int? type;
  bool? isIncv;
  int? sort;
  int? privacy;
  String? created;
  int? status;
  String? imagePath;
  String? uuid;

  DetailActivity(
      {this.title,
      this.content,
      this.link,
      this.fromDate,
      this.toDate,
      this.type,
      this.isIncv,
      this.sort,
      this.privacy,
      this.created,
      this.status,
      this.imagePath,
      this.uuid});

  DetailActivity.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    link = json['link'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    type = json['type'];
    isIncv = json['isIncv'];
    sort = json['sort'];
    privacy = json['privacy'];
    created = json['created'];
    status = json['status'];
    imagePath = json['imagePath'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['link'] = this.link;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['type'] = this.type;
    data['isIncv'] = this.isIncv;
    data['sort'] = this.sort;
    data['privacy'] = this.privacy;
    data['created'] = this.created;
    data['status'] = this.status;
    data['imagePath'] = this.imagePath;
    data['uuid'] = this.uuid;
    return data;
  }
}