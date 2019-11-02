import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/actions.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/widgets/input.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/x/_style/color.dart';

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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CtClose(),
        trailing: ProfileRefresher(
          widget: UpdateProfile(
            input: _value,
            enabled: !(widget.args.name == _value),
            profile: widget.args.profile,
            id: widget.args.id
          ),
        ),
        border: null,
      ),
      child: Input(
        onChanged: changeValue,
        controller: _controller,
        center: false,
        helper: widget.args.profile == 'id' ? '请输入要修改的 id' : '请输入要修改的名字'
      ),
    );
  }
}
