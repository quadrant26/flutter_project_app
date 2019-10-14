import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatefulWidget {

  final String icon;
  final String title;
  final String url;
  final String statusBarColor;
  final bool hideAppBar;

  const WebView({Key key, this.icon, this.title, this.url, this.statusBarColor, this.hideAppBar}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView>{

  final webviewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webviewReference.close();
    //对非http获取https链接判断
    _onUrlChanged = webviewReference.onUrlChanged.listen( (String url){

    });

    _onStateChanged = webviewReference.onStateChanged.listen( (WebViewStateChanged state){
      switch(state.type){
        case WebViewState.startLoad:

          break;
        default:
          break;
      }
    });

    _onHttpError = webviewReference.onHttpError.listen( (WebViewHttpError error){
      print(error);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    webviewReference.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // appbar 颜色操作
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if ( statusBarColorStr == 'ffffff'){
      backButtonColor = Colors.black;
    }else{
      backButtonColor = Colors.white;
    }
    
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
              withZoom: true,
              withLocalStorage: true,
              hidden: true,
              // 默认加载的初始化页面
              initialChild: Container(
                color: Colors.white,
                child: Center(
                  child: Text('Waiting...'),
                ),
              ),
            ),
          )
        ]
      )
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    if( widget.hideAppBar ?? false){
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    return Container(
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 26
                )
              ),
            ),
            Positioned(
              left:0,
              right: 0,
              child: Center(
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(color: backButtonColor, fontSize: 20)
                ),
              ),
            )
          ],
        )
      ),
    );
  }

}