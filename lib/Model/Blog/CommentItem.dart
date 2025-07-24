class CommentItem {
  String? uuid;
  ProfileUser? profileUser;
  String? content;
  String? timeAgo;
  String? created;
  String? updated;
  int? status;

  CommentItem(
      {this.uuid,
        this.profileUser,
        this.content,
        this.timeAgo,
        this.created,
        this.updated,
        this.status});

  CommentItem.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    profileUser = json['profileUser'] != null
        ? new ProfileUser.fromJson(json['profileUser'])
        : null;
    content = json['content'];
    timeAgo = json['timeAgo'];
    created = json['created'];
    updated = json['updated'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    if (this.profileUser != null) {
      data['profileUser'] = this.profileUser!.toJson();
    }
    data['content'] = this.content;
    data['timeAgo'] = this.timeAgo;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['status'] = this.status;
    return data;
  }
}

class ProfileUser {
  String? uuid;
  String? name;
  String? imagePath;

  ProfileUser({this.uuid, this.name, this.imagePath});

  ProfileUser.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['imagePath'] = this.imagePath;
    return data;
  }
}
