import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';

// 设置最大滚动距离
const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState()  => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  final PageController _controller = PageController(
    initialPage: 0,
  );

  List _imageUrls = [
    'http://www.devio.org/io/flutter_app/img/banner/100h10000000q7ght9352.jpg',
    'https://dimg04.c-ctrip.com/images/300h0u000000j05rnD96B_C_500_280.jpg',
    'http://pages.ctrip.com/hotel/201811/jdsc_640es_tab1.jpg',
    'https://dimg03.c-ctrip.com/images/fd/tg/g1/M03/7E/19/CghzfVWw6OaACaJXABqNWv6ecpw824_C_500_280_Q90.jpg',
  ];
  double _appBarAlpha = 0; // appbar 透明度设置

  String resultString = "";
  List<CommonModel> localNavList;
  GridNavModel gridNavModel;
  List<CommonModel> subNavList;
  SalesBoxModel salesBoxList;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  _onScroll(offset){
    // 利用滚动的距离来计算 透明度的值
    double alpha = offset/APPBAR_SCROLL_OFFSET;
    if(alpha <= 0){
      alpha = 0;
    }else if(alpha>=1){
      alpha = 1;
    }

    setState(() {
      _appBarAlpha = alpha;
    });
  }

//  loadData (){
//    HomeDao.fetch().then( (result){
//      setState(() {
//        resultString = json.encode(result);
//      });
//    }).catchError((e){
//      setState(() {
//        resultString = e.toString();
//      });
//    });
//  }

  loadData () async {
    try{
      HomeModel model = await HomeDao.fetch();

      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBoxList = model.salesBox;
        resultString = 'resultString'; //json.encode(subNavList);
      });
    } catch(e){
      setState(() {
        resultString = e.toString();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0Xfff2f2f2),
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: NotificationListener(
              onNotification: (scrollNotication){
                if( scrollNotication is ScrollUpdateNotification && scrollNotication.depth == 0){
                  // 滚动且是列表滚动的时候
                  _onScroll(scrollNotication.metrics.pixels);
                }
              },
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 200,
                    child: Swiper(
                      itemCount: _imageUrls.length,
                      autoplay: true,
                      itemBuilder: (BuildContext context, int index){
                        return Image.network(
                            _imageUrls[index],
                            fit: BoxFit.cover
                        );
                      },
                      pagination: SwiperPagination(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                    child: LocalNav(localNavList: localNavList),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                    child: GridNav(gridNavModel: gridNavModel),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                    child: SubNav(subNavList: subNavList),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                    child: SalesBox(salesBoxList: salesBoxList),
                  ),
                  Container(
                    height: 800,
                    child: ListTile(
                        title: Text(resultString)
                    ),
                  )
                ],
              ),
            )
          ),
          Opacity(
            opacity: _appBarAlpha,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('首页')
                ),
              ),
            ),
          )
        ],
      )
    );
  }

}