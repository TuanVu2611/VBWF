class Individual {
  AddressInfo? addressInfo;
  String? facebook;
  String? zalo;
  String? phoneNumber;
  String? email;
  String? tiktok;
  String? instagram;
  String? youtube;
  String? linkedIn;
  String? hobby;
  InfoExpertise? infoExpertise;
  int? expertiseType;
  String? slogan;
  String? name;
  String? avatar;
  String? banner;
  String? uuid;

  Individual(
      {this.addressInfo,
      this.facebook,
      this.zalo,
      this.phoneNumber,
      this.email,
      this.tiktok,
      this.instagram,
      this.youtube,
      this.linkedIn,
      this.hobby,
      this.infoExpertise,
      this.expertiseType,
      this.slogan,
      this.name,
      this.avatar,
      this.banner,
      this.uuid});

  Individual.fromJson(Map<String, dynamic> json) {
    addressInfo = json['addressInfo'] != null
        ? new AddressInfo.fromJson(json['addressInfo'])
        : null;
    facebook = json['facebook'];
    zalo = json['zalo'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    tiktok = json['tiktok'];
    instagram = json['instagram'];
    youtube = json['youtube'];
    linkedIn = json['linkedIn'];
    hobby = json['hobby'];
    infoExpertise = json['infoExpertise'] != null
        ? new InfoExpertise.fromJson(json['infoExpertise'])
        : null;
    expertiseType = json['expertiseType'];
    slogan = json['slogan'];
    name = json['name'];
    avatar = json['avatar'];
    banner = json['banner'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressInfo != null) {
      data['addressInfo'] = this.addressInfo!.toJson();
    }
    data['facebook'] = this.facebook;
    data['zalo'] = this.zalo;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['tiktok'] = this.tiktok;
    data['instagram'] = this.instagram;
    data['youtube'] = this.youtube;
    data['linkedIn'] = this.linkedIn;
    data['hobby'] = this.hobby;
    if (this.infoExpertise != null) {
      data['infoExpertise'] = this.infoExpertise!.toJson();
    }
    data['expertiseType'] = this.expertiseType;
    data['slogan'] = this.slogan;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['banner'] = this.banner;
    data['uuid'] = this.uuid;
    return data;
  }
}

class AddressInfo {
  String? address1;
  Tp? tp;
  Tp? qh;
  Tp? xa;
  String? uuid;

  AddressInfo({this.address1, this.tp, this.qh, this.xa, this.uuid});

  AddressInfo.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    tp = json['tp'] != null ? new Tp.fromJson(json['tp']) : null;
    qh = json['qh'] != null ? new Tp.fromJson(json['qh']) : null;
    xa = json['xa'] != null ? new Tp.fromJson(json['xa']) : null;
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    if (this.tp != null) {
      data['tp'] = this.tp!.toJson();
    }
    if (this.qh != null) {
      data['qh'] = this.qh!.toJson();
    }
    if (this.xa != null) {
      data['xa'] = this.xa!.toJson();
    }
    data['uuid'] = this.uuid;
    return data;
  }
}

class Tp {
  String? code;
  String? name;
  String? uuid;

  Tp({this.code, this.name, this.uuid});

  Tp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['uuid'] = this.uuid;
    return data;
  }
}

class InfoExpertise {
  String? uuid;
  String? expertiseName;
  String? expertiseDate;
  String? addressInfo;
  Tp? tp;
  Tp? qh;
  Tp? xa;

  InfoExpertise(
      {this.uuid,
      this.expertiseName,
      this.expertiseDate,
      this.addressInfo,
      this.tp,
      this.qh,
      this.xa});

  InfoExpertise.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    expertiseName = json['expertiseName'];
    expertiseDate = json['expertiseDate'];
    addressInfo = json['addressInfo'];
    tp = json['tp'] != null ? new Tp.fromJson(json['tp']) : null;
    qh = json['qh'] != null ? new Tp.fromJson(json['qh']) : null;
    xa = json['xa'] != null ? new Tp.fromJson(json['xa']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['expertiseName'] = this.expertiseName;
    data['expertiseDate'] = this.expertiseDate;
    data['addressInfo'] = this.addressInfo;
    if (this.tp != null) {
      data['tp'] = this.tp!.toJson();
    }
    if (this.qh != null) {
      data['qh'] = this.qh!.toJson();
    }
    if (this.xa != null) {
      data['xa'] = this.xa!.toJson();
    }
    return data;
  }
}
