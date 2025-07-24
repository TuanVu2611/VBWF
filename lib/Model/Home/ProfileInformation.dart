class ProfileInformation {
  String? uuid;
  AddressInfo? addressInfo;
  String? introduce;
  String? facebook;
  String? zalo;
  String? phoneNumber;
  String? email;
  String? tiktok;
  String? instagram;
  String? youtube;
  String? linkedIn;

  ProfileInformation(
      {this.uuid,
        this.addressInfo,
        this.introduce,
        this.facebook,
        this.zalo,
        this.phoneNumber,
        this.email,
        this.tiktok,
        this.instagram,
        this.youtube,
        this.linkedIn});

  ProfileInformation.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    addressInfo = json['addressInfo'] != null
        ? new AddressInfo.fromJson(json['addressInfo'])
        : null;
    introduce = json['introduce'];
    facebook = json['facebook'];
    zalo = json['zalo'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    tiktok = json['tiktok'];
    instagram = json['instagram'];
    youtube = json['youtube'];
    linkedIn = json['linkedIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    if (this.addressInfo != null) {
      data['addressInfo'] = this.addressInfo!.toJson();
    }
    data['introduce'] = this.introduce;
    data['facebook'] = this.facebook;
    data['zalo'] = this.zalo;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['tiktok'] = this.tiktok;
    data['instagram'] = this.instagram;
    data['youtube'] = this.youtube;
    data['linkedIn'] = this.linkedIn;
    return data;
  }
}

class AddressInfo {
  String? uuid;
  String? address1;
  Tp? tp;
  Tp? qh;
  Tp? xa;

  AddressInfo({this.uuid, this.address1, this.tp, this.qh, this.xa});

  AddressInfo.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    address1 = json['address1'];
    tp = json['tp'] != null ? new Tp.fromJson(json['tp']) : null;
    qh = json['qh'] != null ? new Tp.fromJson(json['qh']) : null;
    xa = json['xa'] != null ? new Tp.fromJson(json['xa']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
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
    return data;
  }
}

class Tp {
  String? uuid;
  String? code;
  String? name;

  Tp({this.uuid, this.code, this.name});

  Tp.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}
