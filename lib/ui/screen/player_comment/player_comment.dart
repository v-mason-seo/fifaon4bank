class PlayerComment {
  int id;
  String comment;
  String writerName;
  int spid;
  String created;
  String updated;
  int reportCount;


  PlayerComment({
    this.id,
    this.comment,
    this.writerName,
    this.spid,
    this.created,
    this.updated,
    this.reportCount = 0,
  });


  PlayerComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    writerName = json['writerName'];
    spid = json['spid'];
    created = json['created'];
    updated = json['updated'];
    reportCount = json['reportCount'] ?? 0;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['comment'] = comment;
    data['writerName'] = writerName;
    data['spid'] = spid;
    data['created'] = created;
    data['updated'] = updated;
    data['reportCount'] = reportCount ?? 0;

    return data;
  }

  
}