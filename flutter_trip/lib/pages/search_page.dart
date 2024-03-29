import 'package:flutter/material.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/widget/webview.dart';

const URL = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

class SearchPage extends StatefulWidget{

  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;

  const SearchPage({Key key, this.hideLeft, this.searchUrl=URL, this.keyword, this.hint}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{

  String keyword;
  SearchModel searchModel;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(),
          Expanded(
            flex: 1,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                  itemCount: searchModel?.data?.length ??0,
                  itemBuilder: (BuildContext context, int position){
                    return _item(position);
                  }
              )
            ),
          )
        ],
      )
    );
  }

  _appBar(){
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // appbar 遮罩渐变
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          ),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              leftButtonClick: (){
                Navigator.pop(context);
              },
              onChanged: _onTextChange,
            ),
          ),
        )
      ],
    );
  }

  _item(int position){

    if( searchModel==null || searchModel.data ==null)return null;
    SearchItem item = searchModel.data[position];
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)=>WebView(url: item.url, title: '详情')
          )
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(1),
              child: Image(
                width: 26,
                height: 26,
                image: AssetImage(_typeImage(item.type))
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: _title(item),
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 5),
                  child: _subTitle(item),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _title( SearchItem item){
    if( item==null)return null;
    List<TextSpan> spans = [];
    
    spans.addAll( _keywordTextSpans(item.word, searchModel.keyword));
    spans.add(
      TextSpan(
        text: '  ' + (item.districtname??'') + '  ' + (item.zonename??''),
        style: TextStyle(fontSize: 16, color: Colors.grey)
    ));

    return RichText(text: TextSpan(children: spans));
  }

  _keywordTextSpans (String word, String keyword){
    List<TextSpan> spans = [];
    if( word == null || word.length == 0)return spans;
    List<String> arr = word.split(keyword);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);
    //
    for( int i = 0; i < arr.length; i++){
      //搜索关键字高亮忽略大小写
      if( (i+1) % 2 == 0){
        spans.add(TextSpan(text: keyword, style: keywordStyle));
      }
      String val = arr[i];
      if( val != null && val.length > 0){
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }

  _subTitle( SearchItem item){
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: item.price??'',
            style: TextStyle(fontSize: 16, color: Colors.orange)
          ),
          TextSpan(
            text: "  " + (item.star??''),
            style: TextStyle(fontSize: 16, color: Colors.orange)
          )
        ]
      ),
    );
  }

  _typeImage (String type){
    if(type == null)return 'images/type_travelgroup.png';
    String path = 'travelgroup';

    for( final val in TYPES){
      if( type.contains(val)){
        path = val;
        break;
      }
    }
    return 'images/type_$path.png';
  }

  _onTextChange (text){
    keyword = text;
    if( text.length == 0){
      setState(() {
        searchModel = null;
      });
      return;
    }

    String url = widget.searchUrl+text;
    SearchDao.fetch(url, text).then( (SearchModel model){
      //只有当输入的内容与服务端返回的内容一致时才渲染
      if( model.keyword == keyword){
        setState(() {
          searchModel = model;
        });
      }
    }).catchError( (e){
      print(e);
    });
  }
}