import 'package:flutter/material.dart';

// 首页 search 状态
enum SearchBarType {home, normal, homeLight}

class SearchBar extends StatefulWidget {

  final bool enabled;
  final bool hideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;

  final void Function () leftButtonClick;
  final void Function () rightButtonClick;
  final void Function () speakClick;
  final void Function () inputBoxClick;

  final ValueChanged<String> onChanged;

  const SearchBar({Key key, this.enabled, this.hideLeft, this.searchBarType, this.hint, this.defaultText, this.leftButtonClick, this.rightButtonClick, this.speakClick, this.inputBoxClick, this.onChanged}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();

}

class _SearchBarState extends State<SearchBar>{

  bool showClear = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if( widget.defaultText != null){
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return widget.searchBarType == SearchBarType.normal ? _genNormalSearch() : _genHomeSearch();
  }

  _genNormalSearch (){
    return Container(
      child: Row(
        children: <Widget>[
          _warpTap(
            Container(
              child: widget?.hideLeft ?? false ? null : Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                  size: 26,
              ),
            ),
            widget.leftButtonClick
          ),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _warpTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  '搜索',
                  style: TextStyle(color: Colors.blue, fontSize: 12)
                ),
              ),
              widget.rightButtonClick
          ),
        ],
      ),
    );
  }

  _genHomeSearch (){

  }

  _inputBox (){
    Color inputBoxColor;
    if( widget.searchBarType == SearchBarType.home){
      inputBoxColor = Colors.white;
    }else{
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }

    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal ? Color(0xffA9A9A9) : Colors.blue
          ),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal ? TextField(
              controller: _controller,
              onChanged: _onChanged,
              autofocus: true,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.w300
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                border: InputBorder.none,
                hintText: widget.hint ?? '',
                hintStyle: TextStyle(fontSize: 12)
              ),
            ): _warpTap(
              Container(
                child: Text(
                  widget.defaultText,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey
                  )
                ),
              ),
              widget.inputBoxClick
            ),
          )
        ],
      ),
    );
  }

  _warpTap(Widget child, void Function () callback){
    return GestureDetector(
      onTap: (){
        if(callback != null)callback();
      },
      child: child,
    );
  }

  // 搜索框事件
  _onChanged (String text){
    if( text.length > 0){
      setState(() {
        showClear = true;
      });
    }else{
      setState(() {
        showClear = false;
      });
    }

    if( widget.onChanged != null){
      widget.onChanged(text);
    }
  }

}