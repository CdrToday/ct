import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cdr_today/x/store.dart';
import 'package:cdr_today/widgets/actions.dart' as actions;
import 'package:cdr_today/widgets/editor.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:zefyr/zefyr.dart';

class Edit extends StatefulWidget {
  final ArticleArgs args;
  Edit({ this.args });
  
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  ZefyrController _controller;
  FocusNode _focusNode;
  
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = ZefyrController(_loadDocument(''));
    
    getString("_article").then((res) {
        if (res != null) {
          var document = _loadDocument(res);
          setState(() { _controller = ZefyrController(document); });
        }
    });
  }
  
  @override
  dispose() {
    super.dispose();
  }
  
  Widget build(BuildContext context) {
    print(widget.args.topic);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CtClose(
          onTap: () async {
            final String json = jsonEncode(_controller.document);
            setString('_article', json);
            Navigator.maybePop(context);
          }
        ),
        trailing: QrRefresher(
          widget: EditRefresher(
            widget: actions.Publish(
              args: widget.args,
              zefyrController: _controller,
            )
          ),
        ),
        border: null,
      ),
      child: Editor(
        focusNode: _focusNode,
        controller: _controller,
        edit: true,
      ),
    );
  }
  
  NotusDocument _loadDocument(String article) {
    if (widget.args.edit == true) {
      return NotusDocument.fromJson(jsonDecode(widget.args.document));
    }

    if (article != '' && article != null) {
      return NotusDocument.fromJson(json.decode(article));
    }
    
    var data = r'[{"insert":"\n","attributes":{"heading":1}}]';
    return NotusDocument.fromJson(json.decode(data) as List);
  }
}
