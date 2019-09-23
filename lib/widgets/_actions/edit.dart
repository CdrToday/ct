import 'dart:convert';
import 'dart:io';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/post.dart';
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
  Widget more = More(
    args: args,
    toEdit: toEdit,
    screenshotController: screenshotController,
  );

  Widget post = Post(
    update: update,
    args: args,
    toPreview: toPreview,
    zefyrController: zefyrController,
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

class Post extends StatelessWidget {
  final bool update;
  final ArticleArgs args;
  final ZefyrController zefyrController;
  final VoidCallback toPreview;
  Post({ this.update, this.zefyrController, this.args, this.toPreview });

  @override
  Widget build(BuildContext context) {
    final RefreshBloc _bloc = BlocProvider.of<RefreshBloc>(context);
    final RedditBloc _rbloc = BlocProvider.of<RedditBloc>(context);
    final PostBloc _pbloc = BlocProvider.of<PostBloc>(context);
    
    return Builder(
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
          if (args.community != null) {
            if (update == true) {
              res = await r.updateReddit(document: json, id: args.id);
            } else {
              res = await r.newReddit(
                document: json, community: args.community, type: args.type
              );
            }
          } else {
            if (update == true) {
              res = await r.updatePost(document: json, id: args.id);
            } else {
              res = await r.newPost(document: json);
            }
          }
          
          if (res.statusCode != 200) {
            update == true
            ? snacker(context, '更新失败，请重试')
            : snacker(context, '发布失败，请重试');

            return;
          }

          if (args.community != null) {
            _bloc.dispatch(RedditRefresh(refresh: true));
            _rbloc.dispatch(FetchReddits(refresh: true));
          } else {
            _bloc.dispatch(PostRefresh(refresh: true));
            _pbloc.dispatch(FetchSelfPosts(refresh: true));
          }

          if (update == true) {
            snacker(context, '更新成功', color: Colors.black);
            if (toPreview != null) toPreview();
            return;
          }
          
          Navigator.maybePop(context);
        }
      )
    );
  }

  static List<Widget> toList(BuildContext context, {
      bool update, ArticleArgs args, ZefyrController zefyrController,
  }) {
    return [Post(update: update, args: args, zefyrController: zefyrController)];
  }
}

class More extends StatelessWidget {
  final ArticleArgs args;
  final VoidCallback toEdit;
  final ScreenshotController screenshotController;
  More({ this.args, this.toEdit, this.screenshotController });
  
  @override
  build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
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
    final PostBloc _pbloc = BlocProvider.of<PostBloc>(context);
    
    VoidCallback delete() async {
      final xReq.Requests r = await xReq.Requests.init();

      var res;
      if (args.community != null) {
        res = await r.deleteReddit(id: args.id);
      } else {
        res = await r.deletePost(id: args.id);
      }
      
      if (res.statusCode == 200) {
        if (args.community != null) {
          _bloc.dispatch(RedditRefresh(refresh: true));
          _rbloc.dispatch(FetchReddits(refresh: true));
        } else {
          _bloc.dispatch(PostRefresh(refresh: true));
          _pbloc.dispatch(FetchSelfPosts(refresh: true));
        }
        
        Navigator.maybePop(context);
      } else {
        snacker(context, '删除失败，请重试');
      }
      
      Navigator.maybePop(context);
    }

    VoidCallback alertDelete(BuildContext ctx) {
      Navigator.pop(ctx);
      alert(context, title: '删除文章?', action: delete);
    } 

    VoidCallback share() async {
      Navigator.pop(context);
      File image = await controller.capture(pixelRatio: 1.5);
      String name = DateTime.now().toString();
      await Share.file(name, "$name.png", image.readAsBytesSync(), 'image/png');
    }
    
    return IconButton(
      icon: Icon(Icons.more_horiz),
      onPressed: () async {
        showCupertinoModalPopup(
          context: context,
          builder: (ctx) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text('分享'),
                onPressed: share,
              ),
              CupertinoActionSheetAction(
                child: Text('编辑'),
                onPressed: toEdit,
              ),
              CupertinoActionSheetAction(
                child: Text('删除'),
                onPressed: () => alertDelete(ctx),
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
