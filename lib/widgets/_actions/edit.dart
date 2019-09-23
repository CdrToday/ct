import 'dart:convert';
import 'dart:io';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/reddit.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/x/req.dart' as xReq;
import 'package:cdr_today/navigations/args.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

List<Widget> editActionsProvider(BuildContext context, {
    ArticleArgs args,
    ScreenshotController screenshotController,
    ZefyrController zefyrController,
    VoidCallback toEdit, VoidCallback toPreview, bool edit, bool update,
}) {
  final RefreshBloc _bloc = BlocProvider.of<RefreshBloc>(context);
  final RedditBloc _rbloc = BlocProvider.of<RedditBloc>(context);

  Widget more = BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      if (state is UserInited) {
        if (state.mail == args.mail) {
          return EditActions(
            controller: screenshotController,
            toEdit: toEdit,
            args: args,
          );
        }
      }

      return SizedBox.shrink();
    }
  );

  Widget post = Builder(
    builder: (context) => IconButton(
      icon: Icon(Icons.check),
      onPressed: () async {
        final xReq.Requests r = await xReq.Requests.init();
        final String json = jsonEncode(zefyrController.document);

        FocusScope.of(context).requestFocus(FocusNode());
        if (!zefyrController.document.toPlainText().contains(RegExp(r'\S+'))) {
          snacker(context, '请填写文章内容');
          return;
        }

        var res;
        if (update == true) {
          res = await r.updateReddit(document: json, id: args.id);
        } else {
          res = await r.newReddit(
            document: json, community: args.community, type: args.type
          );
        }
        
        if (res.statusCode != 200) {
          update == true
          ? snacker(context, '更新失败，请重试')
          : snacker(context, '发布失败，请重试');

          return;
        }
        
        _bloc.dispatch(RedditRefresh(refresh: true));
        _rbloc.dispatch(FetchReddits(refresh: true));

        update == true
          ? snacker(context, '更新成功', color: Colors.black)
          : snacker(context, '发布成功', color: Colors.black);
      }
    )
  );
  
  Widget cancel = IconButton(
    icon: Icon(Icons.highlight_off),
    onPressed: toPreview
  );

  if (edit) {
    return [cancel, post];
  } else {
    return [more];
  }
}

class EditActions extends StatelessWidget {
  final ScreenshotController controller;
  final VoidCallback toEdit;
  final ArticleArgs args;
  EditActions({ this.controller, this.toEdit, this.args });

  @override
  Widget build(BuildContext context) {
    final RefreshBloc _bloc = BlocProvider.of<RefreshBloc>(context);
    final RedditBloc _rbloc = BlocProvider.of<RedditBloc>(context);
    
    return IconButton(
      icon: Icon(Icons.more_horiz),
      onPressed: () async {
        showCupertinoModalPopup(
          context: context,
          builder: (ctx) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text('分享'),
                onPressed: () async {
                  Navigator.pop(context);
                  File image = await controller.capture(pixelRatio: 1.5);
                  String name = DateTime.now().toString();
                  await Share.file(name, "$name.png", image.readAsBytesSync(), 'image/png');
                }
              ),
              CupertinoActionSheetAction(
                child: Text('编辑'),
                onPressed: toEdit,
              ),
              CupertinoActionSheetAction(
                child: Text('删除'),
                onPressed: () async {
                  final xReq.Requests r = await xReq.Requests.init();
                  Navigator.pop(ctx);
                  alert(
                    context,
                    title: '删除文章？',
                    action: () async {
                      if (args.community != null) {
                        var res = await r.deleteReddit(id: args.id);
                        if (res.statusCode == 200) {
                          _bloc.dispatch(RedditRefresh(refresh: true));
                          _rbloc.dispatch(FetchReddits(refresh: true));
                          Navigator.maybePop(context);
                        } else {
                          snacker(context, '删除失败，请重试');
                        }

                        Navigator.maybePop(context);
                      }
                    },
                  );
                }
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('取消'),
              onPressed: () => Navigator.pop(context)
            ),
          )
        );
      }
    );
  }
}

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

        FocusScope.of(context).requestFocus(FocusNode());
        if (!document.toPlainText().contains(RegExp(r'\S+'))) {
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
