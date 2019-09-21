import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cdr_today/widgets/_drawer/member.dart';
import 'package:cdr_today/widgets/_drawer/community.dart';

class SwipeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context,int index){
        return index == 0 ? SwipeCommunity() : SwipeMember();
      },
      itemCount: 2,
      loop: false,
      index: 0,
      pagination: SwiperPagination(
        margin: EdgeInsets.only(bottom: kToolbarHeight / 1.2),
        builder: DotSwiperPaginationBuilder(
          activeColor: Colors.grey[400],
          color: Colors.grey[50],
        )
      ),
    );
  }
}
