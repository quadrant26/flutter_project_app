import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 260,
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
            )
          ],
        )
      )
    );
  }

}