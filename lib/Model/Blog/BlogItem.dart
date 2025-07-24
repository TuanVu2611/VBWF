class BlogItem {
  String? title;
  String? imagePath;
  int? catalog;
  int? view;
  int? countComment;
  String? timePublic;
  int? status;
  String? uuid;

  BlogItem(
      {this.title,
        this.imagePath,
        this.catalog,
        this.view,
        this.countComment,
        this.timePublic,
        this.status,
        this.uuid});

  BlogItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    imagePath = json['imagePath'];
    catalog = json['catalog'];
    view = json['view'];
    countComment = json['countComment'];
    timePublic = json['timePublic'];
    status = json['status'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['imagePath'] = this.imagePath;
    data['catalog'] = this.catalog;
    data['view'] = this.view;
    data['countComment'] = this.countComment;
    data['timePublic'] = this.timePublic;
    data['status'] = this.status;
    data['uuid'] = this.uuid;
    return data;
  }
}
