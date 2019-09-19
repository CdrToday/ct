import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/profile.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/navigations/args.dart';

class Name extends StatefulWidget {
  final NameArgs args;
  Name({ this.args });
  
  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  final _controller = TextEditingController();
  String _value = '';
  
  @override
  initState() {
    _value = widget.args.name;
    _controller.value = _controller.value.copyWith(
      text: widget.args.name ?? ''
    );
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void changeValue(String value) {
    setState(() { _value = value; });
  }
  
  Widget build(BuildContext context) {
    final ProfileBloc _bloc = BlocProvider.of<ProfileBloc>(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: [
          Builder(
            builder: (context) => BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileNameCheckedFailed) {
                  Navigator.pop(context);
                  snacker(context, "只能使用纯小写字母");
                } else if (state is ProfileUpdatedSucceed) {
                  Navigator.pop(context);
                  Navigator.maybePop(context);
                } else if (state is ProfileUpdatedFailed) {
                  Navigator.pop(context);
                  snacker(context, "用户名已被使用");
                }
              },
              child: IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  _bloc.dispatch(UpdateProfileName(name: _value));
                  alertLoading(context);
                }
              )
            )
          )
        ],
      ),
      body: Container(
        child: CupertinoTextField(
          autofocus: true,
          onChanged: changeValue,
          style: TextStyle(
            fontSize: 18.0,
          ),
          decoration: BoxDecoration(
            border: null,
          ),
          controller: _controller,
        ),
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
    );
  }
}
