///推荐诗歌Model
class PoemSentenceModel {
  String? cacheAt;
  String? content;
  String? id;
  List<String>? matchTags;
  Origin? origin;
  int? popularity;
  String? recommendedReason;

  PoemSentenceModel(
      {this.cacheAt,
      this.content,
      this.id,
      this.matchTags,
      this.origin,
      this.popularity,
      this.recommendedReason});

  factory PoemSentenceModel.fromJson(Map<dynamic, dynamic> json) {
    return PoemSentenceModel(
      cacheAt: json['cacheAt'],
      content: json['content'],
      id: json['id'],
      matchTags: json['matchTags'] != null
          ? new List<String>.from(json['matchTags'])
          : null,
      origin: json['origin'] != null ? Origin.fromJson(json['origin']) : null,
      popularity: json['popularity'],
      recommendedReason: json['recommendedReason'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cacheAt'] = this.cacheAt;
    data['content'] = this.content;
    data['id'] = this.id;
    data['popularity'] = this.popularity;
    data['recommendedReason'] = this.recommendedReason;
    if (this.matchTags != null) {
      data['matchTags'] = this.matchTags;
    }
    if (this.origin != null) {
      data['origin'] = this.origin!.toJson();
    }
    return data;
  }
}

class Origin {
  String? author;
  List<String>? content;
  String? dynasty;
  String? title;
  List<String>? translate;

  Origin({this.author, this.content, this.dynasty, this.title, this.translate});

  factory Origin.fromJson(Map<String, dynamic> json) {
    return Origin(
      author: json['author'],
      content: json['content'] != null
          ? new List<String>.from(json['content'])
          : null,
      dynasty: json['dynasty'],
      title: json['title'],
      translate: json['translate'] != null
          ? new List<String>.from(json['translate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['dynasty'] = this.dynasty;
    data['title'] = this.title;
    if (this.content != null) {
      data['content'] = this.content;
    }
    if (this.translate != null) {
      data['translate'] = this.translate;
    }
    return data;
  }
}
