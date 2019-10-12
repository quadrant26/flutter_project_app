// 卡片类型
import 'package:flutter_trip/mdel/common_model.dart';

class GridNavModel{
  final GridNavItem hotel;
  final GridNavItem flight;
  final GridNavItem travel;

  GridNavModel({this.hotel, this.flight, this.travel});

  factory GridNavModel.formJson(Map<String, dynamic> json){
    return json != null ? GridNavModel(
      hotel: GridNavItem.formJson(json['hotel']),
      flight: GridNavItem.formJson(json['flight']),
      travel: GridNavItem.formJson(json['travel'])
    ) : null;
  }
}

//"startColor": "fa5956",
//"endColor": "fa9b4d",
//"mainItem": {},
//"item1": {},
//"item2": {},
//"item3": {},
//"item4": {}
class GridNavItem{
  final String startColor;
  final String endColor;
  final CommonModel mainItem;
  final CommonModel item1;
  final CommonModel item2;
  final CommonModel item3;
  final CommonModel item4;

  GridNavItem({this.startColor, this.endColor, this.mainItem, this.item1, this.item2, this.item3, this.item4});

  factory GridNavItem.formJson(Map<String, dynamic> json){
    return GridNavItem(
      startColor: json['startColor'],
      endColor: json['endColor'],
      mainItem: json['mainItem'],
      item1: json['item1'],
      item2: json['item2'],
      item3: json['item3'],
      item4: json['item4'],
    );
  }
}