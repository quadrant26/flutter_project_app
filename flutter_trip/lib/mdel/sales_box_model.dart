
import 'package:flutter_trip/mdel/common_model.dart';

// 活动入口模型
//icon": "http://www.devio.org/io/flutter_app/img/sales_box_huodong.png",
//"moreUrl": "https://contents.ctrip.com/activitysetupapp/mkt/index/moreact",
//"bigCard1": {},
//"bigCard2": {},
//"smallCard1": {},
//"smallCard2": {},
//"smallCard3": {},
//"smallCard4"
class SalesBoxModel{
  final String icon;
  final String moreUrl;
  final CommonModel bigCard1;
  final CommonModel bigCard2;
  final CommonModel smallCard1;
  final CommonModel smallCard2;
  final CommonModel smallCard3;
  final CommonModel smallCard4;

  SalesBoxModel({this.icon, this.moreUrl, this.bigCard1, this.bigCard2, this.smallCard1, this.smallCard2, this.smallCard3, this.smallCard4});

  factory SalesBoxModel.formJson(Map<String, dynamic> json){
    return SalesBoxModel(
      icon: json['icon'],
      moreUrl: json['moreUrl'],
      bigCard1: CommonModel.formJson(json['bigCard1']),
      bigCard2: CommonModel.formJson(json['bigCard2']),
      smallCard1: CommonModel.formJson(json['smallCard1']),
      smallCard2: CommonModel.formJson(json['smallCard2']),
      smallCard3: CommonModel.formJson(json['smallCard3']),
      smallCard4: CommonModel.formJson(json['smallCard4']),
    );
  }
}