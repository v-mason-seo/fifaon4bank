class PlayerNews {
  int id;
  int spid;
  String title;
  String url;
  String thumb;
  String created;


  PlayerNews({
    this.id,
    this.spid,
    this.title,
    this.url,
    this.thumb,
    this.created
  });


  PlayerNews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    spid = json['spid'];
    title = json['title'];
    url = json['url'];
    thumb = json['thumb'];
    created = json['created'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['spid'] = spid;
    data['title'] = title;
    data['url'] = url;
    data['thumb'] = thumb;
    data['created'] = created;

    return data;
  }

}