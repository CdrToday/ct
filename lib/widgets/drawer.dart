import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cdr_today/blocs/drawer.dart';
import 'package:cdr_today/widgets/_drawer/member.dart';
import 'package:cdr_today/widgets/_drawer/community.dart';

class SwipeDrawer extends StatefulWidget {
  @override
  _SwipeDrawerState createState() => _SwipeDrawerState();
}

class _SwipeDrawerState extends State<SwipeDrawer> {
  @override
  Widget build(BuildContext context) {
    final DrawerBloc _bloc = BlocProvider.of<DrawerBloc>(context);
    return BlocBuilder<DrawerBloc, DrawerState>(
      builder: (context, state) {
        if (state is DrawerIndex) {
          return Swiper(
            itemBuilder: (BuildContext context,int index){
              return index == 0 ? SwipeCommunity() : SwipeMember();
            },
            itemCount: 2,
            loop: false,
            index: state.index,
            pagination: SwiperPagination(
              margin: EdgeInsets.only(bottom: kToolbarHeight / 1.2),
              builder: DotSwiperPaginationBuilder(
                activeColor: Colors.grey[400],
                color: Colors.grey[50],
              )
            ),
            onIndexChanged: (int index) => _bloc.dispatch(ChangeDrawerIndex(index: index)),
          );
        }

        return SwipeCommunity();
      }
    );
  }
}
