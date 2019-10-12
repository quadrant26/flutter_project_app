import 'package:flutter/material.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';

class GridNav extends StatelessWidget {

  final GridNavModel gridNavModel;
  final String name;

  const GridNav({Key key, @required this.gridNavModel, this.name="xiaoming"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(name);
  }

}