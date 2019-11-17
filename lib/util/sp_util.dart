import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

///SP工具类
class SPUtil {
  static SPUtil singleton;
  static SharedPreferences sp;
  static Lock _lock = Lock();

  static Future<SPUtil> getInstance() async {
    if (singleton == null) {
//      await _lock.synchronized(() async {
        if (singleton == null) {
          // keep local instance till it is fully initialized.
          // 保持本地实例直到完全初始化。
          var singleton = SPUtil();
          await singleton.init();
          singleton = singleton;
        }
//      });
    }
    return singleton;
  }

  Future init() async {
    sp = await SharedPreferences.getInstance();
  }

  /// put object.
  static Future<bool> putObject(String key, Object value) {
    if (sp == null) return null;
    return sp.setString(key, value == null ? "" : json.encode(value));
  }

  /// get obj.
  static T getObj<T>(String key, T f(Map v), {T defValue}) {
    Map map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  static Map getObject(String key) {
    if (sp == null) return null;
    String _data = sp.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// put object list.
  static Future<bool> putObjectList(String key, List<Object> list) {
    if (sp == null) return null;
    List<String> _dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    return sp.setStringList(key, _dataList);
  }

  /// get obj list.
  static List<T> getObjList<T>(String key, T f(Map v),
      {List<T> defValue = const []}) {
    List<Map> dataList = getObjectList(key);
    List<T> list = dataList?.map((value) {
      return f(value);
    })?.toList();
    return list ?? defValue;
  }

  /// get object list.
  static List<Map> getObjectList(String key) {
    if (sp == null) return null;
    List<String> dataLis = sp.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }

  /// get string.
  static String getString(String key, {String defValue = ''}) {
    if (sp == null) return defValue;
    return sp.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool> putString(String key, String value) {
    if (sp == null) return null;
    return sp.setString(key, value);
  }

  /// get bool.
  static bool getBool(String key, {bool defValue = false}) {
    if (sp == null) return defValue;
    return sp.getBool(key) ?? defValue;
  }

  /// put bool.
  static Future<bool> putBool(String key, bool value) {
    if (sp == null) return null;
    return sp.setBool(key, value);
  }

  /// get int.
  static int getInt(String key, {int defValue = 0}) {
    if (sp == null) return defValue;
    return sp.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool> putInt(String key, int value) {
    if (sp == null) return null;
    return sp.setInt(key, value);
  }

  /// get double.
  static double getDouble(String key, {double defValue = 0.0}) {
    if (sp == null) return defValue;
    return sp.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool> putDouble(String key, double value) {
    if (sp == null) return null;
    return sp.setDouble(key, value);
  }

  /// get string list.
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (sp == null) return defValue;
    return sp.getStringList(key) ?? defValue;
  }

  /// put string list.
  static Future<bool> putStringList(String key, List<String> value) {
    if (sp == null) return null;
    return sp.setStringList(key, value);
  }

  /// get dynamic.
  static dynamic getDynamic(String key, {Object defValue}) {
    if (sp == null) return defValue;
    return sp.get(key) ?? defValue;
  }

  /// have key.
  static bool haveKey(String key) {
    if (sp == null) return null;
    return sp.getKeys().contains(key);
  }

  /// get keys.
  static Set<String> getKeys() {
    if (sp == null) return null;
    return sp.getKeys();
  }

  /// remove.
  static Future<bool> remove(String key) {
    if (sp == null) return null;
    return sp.remove(key);
  }

  /// clear.
  static Future<bool> clear() {
    if (sp == null) return null;
    return sp.clear();
  }

  ///Sp is initialized.
  static bool isInitialized() {
    return sp != null;
  }
}
