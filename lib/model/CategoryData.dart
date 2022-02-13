class CategoryReceipt {
  String method;
  bool status;
  List<Results> results;

  CategoryReceipt({this.method, this.status, this.results});

  CategoryReceipt.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    status = json['status'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method'] = this.method;
    data['status'] = this.status;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String category;
  String url;
  String key;

  Results({this.category, this.url, this.key});

  Results.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    url = json['url'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['url'] = this.url;
    data['key'] = this.key;
    return data;
  }
}