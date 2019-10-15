import 'package:flutter/material.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/dao/search_dao.dart';

class SearchPage extends StatefulWidget{

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{

  String showText;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SearchBar(
            hideLeft: true,
            defaultText: '哈哈',
            hint: '123',
            leftButtonClick: (){
              Navigator.pop(context);
            },
            onChanged: _onTextChange,
          ),
          InkWell(
            onTap: (){
              SearchDao.fetch('https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=长城').then( (SearchModel value){
                setState(() {
                  showText = value.data[0].url;
                });
              }).catchError( (error)=>print(error));
            },
            child: Text('Get'),
          ),
          Text(
            showText
          )
        ],
      )
    );
  }

  _onTextChange (String value){

  }
}