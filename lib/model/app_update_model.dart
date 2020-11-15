/// CheckApp更新接口
class AppUpdateModel {
  String buildBuildVersion;
  bool buildHaveNewVersion;
  String buildShortcutUrl;
  String buildUpdateDescription;
  String buildVersion;
  String buildVersionNo;
  String downloadURL;
  String forceUpdateVersion;
  String forceUpdateVersionNo;
  bool needForceUpdate;

  AppUpdateModel(
      {this.buildBuildVersion,
      this.buildHaveNewVersion,
      this.buildShortcutUrl,
      this.buildUpdateDescription,
      this.buildVersion,
      this.buildVersionNo,
      this.downloadURL,
      this.forceUpdateVersion,
      this.forceUpdateVersionNo,
      this.needForceUpdate});

  factory AppUpdateModel.fromJson(Map<String, dynamic> json) {
    return AppUpdateModel(
      buildBuildVersion: json['buildBuildVersion'],
      buildHaveNewVersion: json['buildHaveNewVersion'],
      buildShortcutUrl: json['buildShortcutUrl'],
      buildUpdateDescription: json['buildUpdateDescription'],
      buildVersion: json['buildVersion'],
      buildVersionNo: json['buildVersionNo'],
      downloadURL: json['downloadURL'],
      forceUpdateVersion: json['forceUpdateVersion'],
      forceUpdateVersionNo: json['forceUpdateVersionNo'],
      needForceUpdate: json['needForceUpdate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buildBuildVersion'] = this.buildBuildVersion;
    data['buildHaveNewVersion'] = this.buildHaveNewVersion;
    data['buildShortcutUrl'] = this.buildShortcutUrl;
    data['buildUpdateDescription'] = this.buildUpdateDescription;
    data['buildVersion'] = this.buildVersion;
    data['buildVersionNo'] = this.buildVersionNo;
    data['downloadURL'] = this.downloadURL;
    data['forceUpdateVersion'] = this.forceUpdateVersion;
    data['forceUpdateVersionNo'] = this.forceUpdateVersionNo;
    data['needForceUpdate'] = this.needForceUpdate;
    return data;
  }
}
