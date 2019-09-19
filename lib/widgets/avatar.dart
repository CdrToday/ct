import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/x/conf.dart';

class AvatarHero extends StatelessWidget {
  final String tag;
  final VoidCallback onTap;
  final double width;
  final bool rect;

  AvatarHero({ @required this.tag, this.onTap, this.width, this.rect });
  
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 2,
      child: Hero(
        tag: tag,
        child: Material(
          child: InkWell(
            onTap: onTap,
            child: avatar(width: width, rect: rect),
            borderRadius: BorderRadius.all(
              Radius.circular(33.0)
            )
          ),
          color: Colors.transparent,
        ),
      )
    );
  }
}

Widget avatar({ double width, bool rect }) {
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      if (state is UserInited) {
        if (state.avatar != null) {
          if (rect) {
            return Container(
              child: Image.network(conf['image'] + state.avatar),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30.0))
              )
            );
          }
          return CircleAvatar(
            radius: width ?? 28.0,
            backgroundImage: NetworkImage(conf['image'] + state.avatar),
          );
        } else if (state.name != null) {
          return CircleAvatar(
            radius: width ?? 28.0,
            backgroundColor: Colors.brown.shade800,
            child: Text(state.name[0].toUpperCase())
          );
        } else {
          return CircleAvatar(
            radius: width ?? 28.0,
            backgroundColor: Colors.brown.shade800,
            child: Text(state.mail[0].toUpperCase())
          );
        }
      }
      return SizedBox.shrink();
    }
  );
}
