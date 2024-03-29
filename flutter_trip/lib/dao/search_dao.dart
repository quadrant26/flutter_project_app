import 'dart:convert';
import 'dart:async';
import 'package:flutter_trip/model/search_model.dart';
import 'package:http/http.dart' as http;

import '../model/home_model.dart';

// 首页数据接口
class SearchDao{
  static Future<SearchModel> fetch(String url, String text) async {
    final response = await http.get(url);

    if( response.statusCode == 200){
      Utf8Decoder utf8decoder = Utf8Decoder(); // 修复中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      SearchModel model = SearchModel.fromJson(result);
      //只有当输入的内容与服务端返回的内容一致时才渲染
      model.keyword = text;
      return model;
    }else{
      throw Exception('Failed to load home_page.json');
    }
  }
}
