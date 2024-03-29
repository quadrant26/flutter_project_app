import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/webview.dart';

// 设置最大滚动距离
const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = "网红打卡地 景点 酒店 美食";

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState()  => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  final PageController _controller = PageController(
    initialPage: 0,
  );

  double _appBarAlpha = 0; // appbar 透明度设置
  String resultString = "";
  List<CommonModel> localNavList;
  List<CommonModel> bannerList;
  GridNavModel gridNavModel;
  List<CommonModel> subNavList;
  SalesBoxModel salesBoxList;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
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

  Future<Null> _handleRefresh () async {
    try{
      HomeModel model = await HomeDao.fetch();

      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBoxList = model.salesBox;
        bannerList = model.bannerList;
        print(bannerList.length);
        _loading = false;
        resultString = 'resultString'; //json.encode(subNavList);
      });
    } catch(e){
      setState(() {
        resultString = e.toString();
        _loading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _loading,
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: NotificationListener(
                  onNotification: (scrollNotication){
                    if( scrollNotication is ScrollUpdateNotification && scrollNotication.depth == 0){
                      // 滚动且是列表滚动的时候
                      _onScroll(scrollNotication.metrics.pixels);
                    }
                  },
                  child: _listView,
                )
              ),
            ),
            _appBar2
          ],
        ),
      )
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
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
    );
  }

  Widget get _appBar{
    return Opacity(
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
    );
  }

  Widget get _appBar2{
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // Appbar 渐变遮罩背景色
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
              color: Color.fromARGB( (_appBarAlpha*255).toInt(), 255, 255, 255 )
            ),
            child: SearchBar(
              searchBarType: _appBarAlpha > 0.2 ? SearchBarType.homeLight : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: (){},
            ),
          ),
        ),
        Container(
          height: _appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]
          ),
        )
      ],
    );
  }

  _jumpToSearch (){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return SearchPage(
        hint: SEARCH_BAR_DEFAULT_TEXT
      );
    }));
  }

  _jumpToSpeak (){

  }

  Widget get _banner {
    return Container(
      height: 200,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index){
          return GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context){
                        CommonModel model = bannerList[index];
                        return WebView(
                          url: model.url,
                          title: model.title,
                          hideAppBar: model.hideAppBar,
                        );
                      })
              );
            },
            child: Image.network(
                bannerList[index].icon,
                fit: BoxFit.cover
            ),
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }
}