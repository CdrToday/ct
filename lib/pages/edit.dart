import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:cdr_today/blocs/article_list.dart';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  String _title;
  String _content;
  
  Widget build(BuildContext context) {
    final EditBloc _bloc = BlocProvider.of<EditBloc>(context);
    final ArticleListBloc _alBloc = BlocProvider.of<ArticleListBloc>(context);
    
    return BlocListener<EditBloc, EditState>(
      listener: (context, state) {
        if (state is PublishSucceed) {
          _alBloc.dispatch(ReFetching());
          Navigator.pushNamedAndRemoveUntil(context, '/init', (_) => false);
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('发布失败，请重试'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('编辑'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () => _bloc.dispatch(CompletedEdit(title: _title, content: _content))
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: '标题',),
                scrollPadding: EdgeInsets.all(20.0),
                onChanged: (String text) => setState(() { _title = text; })
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '内容',
                  ),
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  onChanged: (String text) => setState(() { _content = text; })
                ),
              ),
            ],
          ),
          padding: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
        ),
        resizeToAvoidBottomPadding: true,
      )
    );
  }
}
