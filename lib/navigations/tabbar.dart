import 'package:flutter/material.dart';
import 'package:cdr_today/pages/mine.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/pages/publish.dart';
import 'package:cdr_today/pages/article_list.dart';

// configs
dynamic configs(BuildContext context) => [{
    'title': Text('文章列表'),
    'child': ArticleList(),
    'actions': [
      SizedBox.shrink()
    ],
  }, {
    'title': Text('发表'),
    'child': Publish(),
    'actions': [
      SizedBox.shrink()
    ]
  }, {
    'title': Text('我'),
    'child': Mine(),
    'actions': [
      SizedBox.shrink()
    ]
}];

// TabNavigator
class TabNavigator extends StatefulWidget {
  final int index;
  final bool fetch;
  TabNavigator({
      Key key, this.index, this.fetch
  }) : super(key: key);

  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  UserBloc _userBloc;

  int _currentIndex = 0;
  void onTapped(int index) {
    setState(() { _currentIndex = index;});
  }
  
  // if args
  @override
  Widget build(BuildContext context) {
    dynamic conf = configs(context);

    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: conf[_currentIndex]['title'],
        actions: conf[_currentIndex]['actions'],
      ),
      body: conf[_currentIndex]['child'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('')
          )
        ],
      ),
    );
  }
}
