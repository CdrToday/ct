import 'package:flutter/material.dart';
import 'package:cdr_today/blocs/user.dart';

// configs
dynamic configs(BuildContext context) => [{
    'title': Text('文章列表'),
    'child': Text('文章列表'),
    'actions': [
      SizedBox.shrink()
    ],
  }, {
    'title': Text('社区'),
    'child': Text('社区'),
    'actions': [
      SizedBox.shrink()
    ]
  }, {
    'title': Text('我'),
    'child': Text('我'),
    'actions': [
      SizedBox.shrink()
    ]
}];

// TabNavigator
class TabNavigator extends StatefulWidget {
  final int index;
  TabNavigator({Key key, @required this.index}) : super(key: key);
  
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  UserBloc _userBloc;

  int _currentIndex = 0;
  void onTapped(int index) {
    setState(() { _currentIndex = index;});
  }
  
  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.dispatch(InitUser());

    _currentIndex = widget.index;
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
            icon: Icon(Icons.group),
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
