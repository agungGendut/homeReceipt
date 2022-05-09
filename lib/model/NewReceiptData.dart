class NewReceipt {
  String method;
  bool status;
  List<ResultReceipt> results;

  NewReceipt({this.method, this.status, this.results});

  NewReceipt.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    status = json['status'];
    if (json['results'] != null) {
      results = <ResultReceipt>[];
      json['results'].forEach((v) {
        results.add(new ResultReceipt.fromJson(v));
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

class ResultReceipt {
  String title;
  String thumb;
  String key;
  String times;
  String portion;
  String dificulty;

  ResultReceipt(
      {this.title,
        this.thumb,
        this.key,
        this.times,
        this.portion,
        this.dificulty});

  ResultReceipt.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    thumb = json['thumb'];
    key = json['key'];
    times = json['times'];
    portion = json['portion'];
    dificulty = json['dificulty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['thumb'] = this.thumb;
    data['key'] = this.key;
    data['times'] = this.times;
    data['portion'] = this.portion;
    data['dificulty'] = this.dificulty;
    return data;
  }
}