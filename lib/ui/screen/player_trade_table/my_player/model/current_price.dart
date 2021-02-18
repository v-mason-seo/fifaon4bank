class CurrentPrice {
  int priceSn;
  int grade;
  int spid;
  int maxPrice;
  int minPrice;
  int presentPrice;
  String updated;
  double amountMultiple;
  List<String> times;
  List<int> prices;

  CurrentPrice({
    this.priceSn,
    this.grade,
    this.spid,
    this.maxPrice = 0,
    this.minPrice = 0,
    this.presentPrice = 0,
    this.updated,
  });


  @override
  String toString() {
    return """CurrentPrice(
      priceSn: $priceSn,
      grade: $grade,
      spid: $spid,
      maxPrice: $maxPrice,
      minPrice: $minPrice,
      presentPrice: $presentPrice,
      updated: $updated,
      times: ${times != null ? times : ""},
      prices: ${prices != null ? prices : ""}
    )
    """;
  }


  CurrentPrice.fromJson(Map<String, dynamic> json) {
    priceSn = json['priceSn'];
    grade = json['grade'];
    spid = json['spid'];
    maxPrice = json['maxPrice'];
    minPrice = json['minPrice'];
    presentPrice = json['presentPrice'];
    updated = json['updated'];
    
    if ( json['times'] != null ) {
      times = List<String>.from(json['times']);
    }

    if ( json['prices'] != null ) {
      prices = List<int>.from(json['prices']);
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['priceSn'] = priceSn;
    data['grade'] = grade;
    data['spid'] = spid;
    data['maxPrice'] = maxPrice;
    data['minPrice'] = minPrice;
    data['presentPrice'] = presentPrice;
    data['updated'] = updated;
    data['times'] = times != null ? Map.fromIterable(times) : null;
    data['prices'] = prices != null ? Map.fromIterable(prices) : null;

    return data;
  }
}