
import './config_model.dart';
import './common_model.dart';
import './grid_nav_model.dart';
import './sales_box_model.dart';

class HomeModel{
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final List<CommonModel> subNavList;
  final GridNavModel gridNav;
  final SalesBoxModel salesBox;

  HomeModel({this.config, this.bannerList, this.localNavList, this.subNavList, this.gridNav, this.salesBox});

  factory HomeModel.fromJson(Map<String, dynamic> json){

    var localNavListJson = json['localNavList'] as List;
    List<CommonModel> localNavList = localNavListJson.map( (i) => CommonModel.fromJson(i)).toList();
    var bannerListJson = json['localNavList'] as List;
    List<CommonModel> bannerList = bannerListJson.map( (i) => CommonModel.fromJson(i)).toList();
    var subNavListJson = json['localNavList'] as List;
    List<CommonModel> subNavList = subNavListJson.map( (i) => CommonModel.fromJson(i)).toList();


    return HomeModel(
      config: ConfigModel.fromJson(json['config']),
      bannerList: bannerList,
      localNavList: localNavListJson,
      subNavList: subNavList,
      gridNav: GridNavModel.fromJson(json['gridNav']),
      salesBox: SalesBoxModel.fromJson(json['salesBox']),
    );
  }
}