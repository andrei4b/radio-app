class Member {
  String memberDescription;
  String memberId;
  String memberName;
  MemberPhoto memberPhoto;
  String memberPosition;
  MemberPhoto memberThumbnail;
  String objectId;

  Member(
      {this.memberDescription,
      this.memberId,
      this.memberName,
      this.memberPhoto,
      this.memberPosition,
      this.memberThumbnail,
      this.objectId});



  Member.fromJson(Map<String, dynamic> json) {
    memberDescription = json['memberDescription'];
    memberId = json['memberId'];
    memberName = json['memberName'];
    memberPhoto = json['memberPhoto'] != null
        ? new MemberPhoto.fromJson(json['memberPhoto'])
        : null;
    memberPosition = json['memberPosition'];
    memberThumbnail = json['memberThumbnail'] != null
        ? new MemberPhoto.fromJson(json['memberThumbnail'])
        : null;
    objectId = json['objectId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberDescription'] = this.memberDescription;
    data['memberId'] = this.memberId;
    data['memberName'] = this.memberName;
    if (this.memberPhoto != null) {
      data['memberPhoto'] = this.memberPhoto.toJson();
    }
    data['memberPosition'] = this.memberPosition;
    if (this.memberThumbnail != null) {
      data['memberThumbnail'] = this.memberThumbnail.toJson();
    }
    data['objectId'] = this.objectId;
    return data;
  }
}

class MemberPhoto {
  String sType;
  String name;
  String url;

  MemberPhoto({this.sType, this.name, this.url});

  MemberPhoto.fromJson(Map<String, dynamic> json) {
    sType = json['__type'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__type'] = this.sType;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
