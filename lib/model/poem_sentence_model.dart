import 'package:flustars/flustars.dart';

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

  String getTooltip() {
    return origin != null ? origin!.getTooltip() : '';
  }

  String get contentStr => origin != null ? origin!.getContentStr() : '';

  String get dynastyAuthor => origin != null ? origin!.dynastyAuthor : '';

  String get translate => origin != null ? origin!.getTranslateStr() : '';

  String get title => origin != null ? '${origin!.title}' : '';
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

  ///
  String getTooltip() {
    String result = '';
    if (!TextUtil.isEmpty(title)) {
      result += title!;
    }
    if (!TextUtil.isEmpty(author)) {
      result += !TextUtil.isEmpty(result) ? '\n$dynastyAuthor' : dynastyAuthor;
    }
    result = getContentStr(result: result);
    if (translate != null && translate!.isNotEmpty) {
      result += '\n译文：';
      translate!.forEach((element) {
        result += !TextUtil.isEmpty(result) ? '\n$element' : element;
      });
    }
    return result;
  }

  ///朝代+作者
  String get dynastyAuthor => TextUtil.isEmpty(author)
      ? ''
      : TextUtil.isEmpty(dynasty)
          ? author!
          : '$dynasty•$author';

  ///诗歌全文
  String getContentStr({String result: ''}) {
    if (content != null && content!.isNotEmpty) {
      content!.forEach((element) {
        result += !TextUtil.isEmpty(result) ? '\n$element' : element;
      });
    }
    return result;
  }

  ///译文
  String getTranslateStr({String result: ''}) {
    if (translate != null && translate!.isNotEmpty) {
      result += !TextUtil.isEmpty(result) ? '译文:' : '译文:';
      translate!.forEach((element) {
        result += '\n$element';
      });
    }
    return result;
  }
}
