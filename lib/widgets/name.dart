import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';

class Name extends StatelessWidget {
  final bool self;
  final double size;
  final List<String> list;

  Name({ this.self = false, this.size, this.list });
  
  @override
  Widget build(BuildContext context) {
    Widget _name(List<String> arr) {
      if (arr == null) arr = ['?'];
      
      for (var i in arr) {
        if (i == null) continue;

        return size != null
        ? Text(i, style: TextStyle(fontSize: size))
        : Text(i, style: Theme.of(context).textTheme.title);
      }
    }

    return self ? BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInited) {
          return list == null ? _name(
            [state.name]
          ) : _name(
            [state.name] + list
          );
        }
      }
    ) : _name(list);
  }
}
