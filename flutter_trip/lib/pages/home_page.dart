import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/home_model.dart';

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
    'http://b.hiphotos.baidu.com/image/pic/item/0eb30f2442a7d9337119f7dba74bd11372f001e0.jpg',
    'http://a.hiphotos.baidu.com/image/pic/item/9a504fc2d5628535bdaac29e9aef76c6a6ef63c2.jpg',
    'http://g.hiphotos.baidu.com/image/pic/item/21a4462309f7905296a7578106f3d7ca7acbd5d0.jpg'
  ];
  double _appBarAlpha = 0; // appbar 透明度设置

  String resultString = "";

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
        resultString = json.encode(model);
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