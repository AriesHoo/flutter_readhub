
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Provider帮助类
class ProviderHelper{

  static T of<T>(BuildContext context, {bool listen = false}){
    return Provider.of<T>(context,listen: listen);
  }
}