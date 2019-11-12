import 'package:flutter_readhub/util/log_util.dart';

///列表数据
class ListModel {
  List<Data> data;
  int pageSize;
  int totalItems;
  int totalPages;

  ListModel({this.data, this.pageSize, this.totalItems, this.totalPages});

  String getLastCursor() {
    return data == null ? "" : data[data.length - 1].getLastCursor();
  }

  ListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        Data item = new Data.fromJson(v);
        item.parseTimeLong();
        data.add(item);
      });
    }
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['pageSize'] = this.pageSize;
    data['totalItems'] = this.totalItems;
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class Data {
  String id;
  List<NewsArray> newsArray;
  String createdAt;
  List<EventData> eventData;
  String publishDate;
  String summary;
  String title;
  String updatedAt;
  String timeline;
  int order;
  bool hasInstantView;
  Extra extra;
  bool maxLine = true;

  ///时间戳-utc时间
  int publishTime;
  String timeStr = "";
  String siteName;
  String authorName;
  String url;
  String mobileUrl;

  String getUrl() {
    return mobileUrl ?? url ?? newsArray != null && newsArray.length > 0
        ? newsArray[0].mobileUrl
        : "";
  }

  String getSiteName() {
    String str = "";
    if (siteName == null) {
      if (newsArray != null) {
        NewsArray item = newsArray[0];
        str = newsArray.length > 1
            ? '${item.siteName} 等 ${newsArray.length} 家媒体报道'
            : '来着 ${item.siteName} 的报道';
      }
    } else {
      str = '来着 $siteName 的报道';
    }
    return str + "\n"+'扫描看详情';
  }

  ///时间转换
  void parseTimeLong() {
    String targetTime = createdAt == null ? publishDate : createdAt;
    try {
      String time =
          targetTime.replaceAll("Z", "").replaceAll("T", " ").substring(0, 19);
      DateTime createTime = DateTime.parse(time);
      DateTime nowTime = DateTime.now();
      Duration hourDiff = nowTime.difference(createTime);
      if (hourDiff.inDays > 0) {
        if (hourDiff.inDays == 1) {
          timeStr = "昨天";
        } else if (hourDiff.inDays == 1) {
          timeStr = "前天";
        } else {
          timeStr = hourDiff.inDays.toString() + " 天前";
        }
      } else if (hourDiff.inHours > 0) {
        timeStr = hourDiff.inHours.toString() + " 小时前";
      } else if (hourDiff.inMinutes > 0) {
        timeStr = hourDiff.inMinutes.toString() + " 分钟前";
      } else {
        timeStr = "刚刚";
      }
    } catch (e) {
      LogUtil.e("parseTimeLong:" + e.toString());
    }
  }

  switchMaxLine() {
    maxLine = !maxLine;
  }

  Data(
      {this.id,
      this.newsArray,
      this.createdAt,
      this.eventData,
      this.publishDate,
      this.summary,
      this.title,
      this.updatedAt,
      this.timeline,
      this.order,
      this.hasInstantView,
      this.extra});

  String getLastCursor() {
    return order != null ? order.toString() : "";
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    if (json['newsArray'] != null) {
      newsArray = new List<NewsArray>();
      json['newsArray'].forEach((v) {
        newsArray.add(new NewsArray.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    if (json['eventData'] != null) {
      eventData = new List<EventData>();
      json['eventData'].forEach((v) {
        eventData.add(new EventData.fromJson(v));
      });
    }
    if (json['siteName'] != null) {
      siteName = json['siteName'];
    }
    if (json['authorName'] != null) {
      authorName = json['authorName'];
    }
    if (json['url'] != null) {
      url = json['url'];
    }
    if (json['mobileUrl'] != null) {
      mobileUrl = json['mobileUrl'];
    }
    publishDate = json['publishDate'];
    summary = json['summary'];
    title = json['title'];
    updatedAt = json['updatedAt'];
    timeline = json['timeline'];
    order = json['order'];
    hasInstantView = json['hasInstantView'];
    extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.newsArray != null) {
      data['newsArray'] = this.newsArray.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    if (this.eventData != null) {
      data['eventData'] = this.eventData.map((v) => v.toJson()).toList();
    }
    data['publishDate'] = this.publishDate;
    data['summary'] = this.summary;
    data['title'] = this.title;
    data['updatedAt'] = this.updatedAt;
    data['timeline'] = this.timeline;
    data['order'] = this.order;
    data['hasInstantView'] = this.hasInstantView;
    if (this.extra != null) {
      data['extra'] = this.extra.toJson();
    }
    return data;
  }
}

class NewsArray {
  int id;
  String url;
  String title;
  String siteName;
  String mobileUrl;
  String autherName;
  int duplicateId;
  String publishDate;
  String language;
  int statementType;

  NewsArray(
      {this.id,
      this.url,
      this.title,
      this.siteName,
      this.mobileUrl,
      this.autherName,
      this.duplicateId,
      this.publishDate,
      this.language,
      this.statementType});

  NewsArray.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    title = json['title'];
    siteName = json['siteName'];
    mobileUrl = json['mobileUrl'];
    autherName = json['autherName'];
    duplicateId = json['duplicateId'];
    publishDate = json['publishDate'];
    language = json['language'];
    statementType = json['statementType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['title'] = this.title;
    data['siteName'] = this.siteName;
    data['mobileUrl'] = this.mobileUrl;
    data['autherName'] = this.autherName;
    data['duplicateId'] = this.duplicateId;
    data['publishDate'] = this.publishDate;
    data['language'] = this.language;
    data['statementType'] = this.statementType;
    return data;
  }
}

class EventData {
  int id;
  String topicId;
  int eventType;
  String entityId;
  String entityType;
  String entityName;
  int state;
  String createdAt;
  String updatedAt;

  EventData(
      {this.id,
      this.topicId,
      this.eventType,
      this.entityId,
      this.entityType,
      this.entityName,
      this.state,
      this.createdAt,
      this.updatedAt});

  EventData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topicId = json['topicId'];
    eventType = json['eventType'];
    entityId = json['entityId'];
    entityType = json['entityType'];
    entityName = json['entityName'];
    state = json['state'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topicId'] = this.topicId;
    data['eventType'] = this.eventType;
    data['entityId'] = this.entityId;
    data['entityType'] = this.entityType;
    data['entityName'] = this.entityName;
    data['state'] = this.state;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Extra {
  bool instantView;

  Extra({this.instantView});

  Extra.fromJson(Map<String, dynamic> json) {
    instantView = json['instantView'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['instantView'] = this.instantView;
    return data;
  }
}
