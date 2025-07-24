class DetailCV {
  String? uuid;
  String? name;
  String? email;
  String? address;
  int? gender;
  String? birthday;
  int? height;
  int? weight;
  String? phoneNumber;
  String? introduce;
  String? skill;
  String? hobby;
  String? imagePath;
  List<Activity>? experiences;
  List<Activity>? educations;
  List<Activity>? activities;
  List<Activity>? awards;
  bool? isHasCv;

  DetailCV(
      {this.uuid,
      this.name,
      this.email,
      this.address,
      this.gender,
      this.birthday,
      this.height,
      this.weight,
      this.phoneNumber,
      this.introduce,
      this.skill,
      this.hobby,
      this.imagePath,
      this.experiences,
      this.educations,
      this.activities,
      this.awards,
      this.isHasCv});

  DetailCV.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    gender = json['gender'];
    birthday = json['birthday'];
    height = json['height'];
    weight = json['weight'];
    phoneNumber = json['phoneNumber'];
    introduce = json['introduce'];
    skill = json['skill'];
    hobby = json['hobby'];
    imagePath = json['imagePath'];
    if (json['experiences'] != null) {
      experiences = <Activity>[];
      json['experiences'].forEach((v) {
        experiences!.add(new Activity.fromJson(v));
      });
    }
    if (json['educations'] != null) {
      educations = <Activity>[];
      json['educations'].forEach((v) {
        educations!.add(new Activity.fromJson(v));
      });
    }
    if (json['activities'] != null) {
      activities = <Activity>[];
      json['activities'].forEach((v) {
        activities!.add(new Activity.fromJson(v));
      });
    }
    if (json['awards'] != null) {
      awards = <Activity>[];
      json['awards'].forEach((v) {
        awards!.add(new Activity.fromJson(v));
      });
    }
    isHasCv = json['isHasCv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['birthday'] = this.birthday;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['phoneNumber'] = this.phoneNumber;
    data['introduce'] = this.introduce;
    data['skill'] = this.skill;
    data['hobby'] = this.hobby;
    data['imagePath'] = this.imagePath;
    if (this.experiences != null) {
      data['experiences'] = this.experiences!.map((v) => v.toJson()).toList();
    }
    if (this.educations != null) {
      data['educations'] = this.educations!.map((v) => v.toJson()).toList();
    }
    if (this.activities != null) {
      data['activities'] = this.activities!.map((v) => v.toJson()).toList();
    }
    if (this.awards != null) {
      data['awards'] = this.awards!.map((v) => v.toJson()).toList();
    }
    data['isHasCv'] = this.isHasCv;
    return data;
  }
}

class Activity {
  String? uuid;
  String? title;
  String? content;
  String? fromDate;
  String? toDate;
  int? type;
  bool? isIncv;
  int? status;

  Activity(
      {this.uuid,
      this.title,
      this.content,
      this.fromDate,
      this.toDate,
      this.type,
      this.isIncv,
      this.status});

  Activity.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    title = json['title'];
    content = json['content'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    type = json['type'];
    isIncv = json['isIncv'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['title'] = this.title;
    data['content'] = this.content;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['type'] = this.type;
    data['isIncv'] = this.isIncv;
    data['status'] = this.status;
    return data;
  }
}