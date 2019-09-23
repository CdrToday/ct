import 'dart:convert';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/reddit.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/x/req.dart' as xReq;

// edit Actions
List<Widget> editActions(
  BuildContext context, {
    NotusDocument document,
    String id,
    bool edit
  }
) {
  final EditBloc _bloc = BlocProvider.of<EditBloc>(context);
  
  Widget delete = IconButton(
    icon: Icon(Icons.highlight_off),
    onPressed: () => deleteArticle(context, id)
  );

  Widget empty = SizedBox.shrink();
  if (edit != true) delete = empty;

  Builder post = Builder(
    builder: (context) => IconButton(
      icon: Icon(Icons.check),
      onPressed: () {
        String json = jsonEncode(document);

        FocusScope.of(context).requestFocus(new FocusNode());
        if (!document.toPlainText().contains(new RegExp(r'\S+'))) {
          snacker(context, '请填写文章内容');
          return;
        }
        
        if (edit != true) {
          _bloc.dispatch(CompletedEdit(document: json));
        } else {
          _bloc.dispatch(UpdateEdit(id: id, document: json));
        }
      }
    )
  );
  
  return [delete, post];
}

// edit Actions
List<Widget> editRedditActions(
  BuildContext context, {
    NotusDocument document,
    String community,
    String id,
    bool edit,
  }
) {
  final RefreshBloc _bloc = BlocProvider.of<RefreshBloc>(context);
  final RedditBloc _rbloc = BlocProvider.of<RedditBloc>(context);
  
  Widget delete = IconButton(
    icon: Icon(Icons.highlight_off),
    onPressed: () => deleteArticle(context, id)
  );

  Widget empty = SizedBox.shrink();
  if (edit != true) delete = empty;
  
  Builder post = Builder(
    builder: (context) => IconButton(
      icon: Icon(Icons.check),
      onPressed: () async {
        final xReq.Requests r = await xReq.Requests.init();
        final String json = jsonEncode(document);

        FocusScope.of(context).requestFocus(FocusNode());
        if (!document.toPlainText().contains(RegExp(r'\S+'))) {
          snacker(context, '请填写文章内容');
          return;
        }
        
        var res;
        if (edit == false) {
          res = await r.newReddit(
            document: json, community: community, type: 'article'
          );
        } else {
          res = await r.updateReddit(document: json, id: id);
        }
        
        if (res.statusCode != 200) {
          edit == false
          ? snacker(context, '发送失败，请重试')
          : snacker(context, '更新失败，请重试');

          return;
        }
        
        _bloc.dispatch(RedditRefresh(refresh: true));
        _rbloc.dispatch(FetchReddits(refresh: true));
        Navigator.pop(context);
      }
    )
  );
  
  return [delete, post];
}
