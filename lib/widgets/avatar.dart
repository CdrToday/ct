import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/x/conf.dart';

class AvatarHero extends StatelessWidget {
  final String tag;
  final VoidCallback onTap;
  final double width;
  final bool rect;
  final bool self;
  final String url;
  final List<String> baks;

  AvatarHero({
      this.url,
      this.baks,
      this.onTap,
      this.tag = '',
      this.self = false,
      this.width = 24.0,
      this.rect = false,
  });
  
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 2,
      child: Hero(
        tag: tag,
        child: Material(
          child: InkWell(
            onTap: onTap,
            child: self ? BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserInited) {
                  return Avatar(
                    width: width,
                    rect: rect,
                    url: state.avatar,
                    baks: [state.name, state.mail]
                  );
                }
                return Avatar(width: width, rect: rect);
              }
            ) : Avatar(
              width: width,
              rect: rect,
              url: url,
              baks: baks,
            ),
            borderRadius: BorderRadius.all(Radius.circular(33.0))
          ),
          color: Colors.transparent,
        ),
      )
    );
  }
}

class Avatar extends StatelessWidget {
  final double width;
  final bool rect;
  final String url;
  final List<String> baks;
  
  Avatar({
      this.width,
      this.rect = false,
      this.url,
      this.baks
  });

  Widget build(BuildContext context) {
    // if (baks == null) _baks = [];
    if (url != null) {
      if (rect) {
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.network(
            conf['image'] + url,
            fit:BoxFit.cover,
          ),
        );
      }
      return CircleAvatar(
        radius: width,
        backgroundImage: NetworkImage(conf['image'] + url),
      );
    } 

    // use baks string;
    var _baks;
    baks != null ? _baks = baks : _baks = ['?'];
    for (var i in _baks) {
      if (i == null) continue;
      if (rect) {
        return SizedBox(
          child: Container(
            child: Text(i[0], style: TextStyle(color: Colors.white, fontSize: width)),
            decoration: BoxDecoration(
              color: Colors.brown.shade800,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            alignment: Alignment.center
          ),
          height: width * 2,
        );
      }

      return CircleAvatar(
        radius: width,
        backgroundColor: Colors.brown.shade800,
        child: Text(i[0])
      );
    }

    return CircleAvatar(
      radius: width,
      backgroundColor: Colors.brown.shade800,
      child: Text('?')
    );
  }
}
