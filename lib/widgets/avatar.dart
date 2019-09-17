import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/x/conf.dart';

Widget avatar() {
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      if (state is UserInited) {
        if (state.avatar != null) {
          return CircleAvatar(
            radius: 28.0,
            backgroundImage: NetworkImage(conf['image'] + state.avatar),
          );
        } else if (state.name != null) {
          return CircleAvatar(
            backgroundColor: Colors.brown.shade800,
            child: Text(state.name[0].toUpperCase())
          );
        } else {
          return CircleAvatar(
            backgroundColor: Colors.brown.shade800,
            child: Text(state.mail[0].toUpperCase())
          );
        }
      }
      return SizedBox.shrink();
    }
  );
}
