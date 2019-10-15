
const URL = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

class SearchModel{
  final List<SearchItem> data;

  String keyword;

  SearchModel({this.data});

  factory SearchModel.fromJson(Map<String, dynamic> json){
    var dataJson = json['data'] as List;
    List<SearchItem> data = dataJson.map( (i) => SearchItem.fromJson(i)).toList();

    return SearchModel(data: data);
  }
}

class SearchItem {
  String word;
  String type;
  String districtname;
  String url;
  String price;
  String star;
  String zonename;

  SearchItem(
      {this.word,
        this.type,
        this.districtname,
        this.url,
        this.price,
        this.star,
        this.zonename});

  SearchItem.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    type = json['type'];
    districtname = json['districtname'];
    url = json['url'];
    price = json['price'];
    star = json['star'];
    zonename = json['zonename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['type'] = this.type;
    data['districtname'] = this.districtname;
    data['url'] = this.url;
    data['price'] = this.price;
    data['star'] = this.star;
    data['zonename'] = this.zonename;
    return data;
  }
}