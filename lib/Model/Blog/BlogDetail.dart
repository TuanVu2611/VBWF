class BlogDetail {
  String? uuid;
  String? title;
  String? content;
  int? catalog;
  int? view;
  String? timePublic;
  String? link;
  String? imagePath;
  int? status;
  int? countComment;
  bool? blockComment;

  BlogDetail(
      {this.uuid,
        this.title,
        this.content,
        this.catalog,
        this.view,
        this.timePublic,
        this.link,
        this.imagePath,
        this.status,
        this.countComment,
        this.blockComment});

  BlogDetail.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    title = json['title'];
    content = json['content'];
    catalog = json['catalog'];
    view = json['view'];
    timePublic = json['timePublic'];
    link = json['link'];
    imagePath = json['imagePath'];
    status = json['status'];
    countComment = json['countComment'];
    blockComment = json['blockComment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['title'] = this.title;
    data['content'] = this.content;
    data['catalog'] = this.catalog;
    data['view'] = this.view;
    data['timePublic'] = this.timePublic;
    data['link'] = this.link;
    data['imagePath'] = this.imagePath;
    data['status'] = this.status;
    data['countComment'] = this.countComment;
    data['blockComment'] = this.blockComment;
    return data;
  }
}
