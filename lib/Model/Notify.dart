class Notify {
  String? uuid;
  String? title;
  String? content;
  String? accountUuid;
  String? timeAgo;
  String? created;
  int? type;
  int? state;

  Notify({
    this.uuid,
    this.title,
    this.content,
    this.accountUuid,
    this.timeAgo,
    this.created,
    this.type,
    this.state,
  });

  Notify.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    title = json['title'];
    content = json['content'];
    accountUuid = json['accountUuid'];
    timeAgo = json['timeAgo'];
    created = json['created'];
    type = json['type'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['title'] = title;
    data['content'] = content;
    data['accountUuid'] = accountUuid;
    data['timeAgo'] = timeAgo;
    data['created'] = created;
    data['type'] = type;
    data['state'] = state;
    return data;
  }
}
