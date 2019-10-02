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
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/x/req.dart' as xReq;
import 'package:cdr_today/navigations/args.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class EditActionsProvider {
  final BuildContext context;
  final bool update;
  final ArticleArgs args;
  final VoidCallback toEdit;
  final VoidCallback toPreview;
  final ZefyrController zefyrController;
  final ScreenshotController screenshotController;
    
  EditActionsProvider(
    this.context, {
      this.args,
      this.screenshotController,
      this.zefyrController,
      this.toEdit,
      this.toPreview,
      this.update,
    }
  );

  Widget get more => More(
    args: args,
    update: update,
    toEdit: toEdit,
    zefyrController: zefyrController,
    screenshotController: screenshotController,
  );


  Widget get post => Post(
    update: update,
    args: args,
    toPreview: toPreview,
    zefyrController: zefyrController,
  );
  
  Widget get cancel => NoRipple(
    icon: Icon(Icons.highlight_off),
    onTap: toPreview
  );
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
      builder: (context) => NoRipple(
        icon: Icon(Icons.check),
        onTap: () async {
          final xReq.Requests r = await xReq.Requests.init();
          final String json = jsonEncode(zefyrController.document);

          FocusScope.of(context).requestFocus(FocusNode());
          if (!zefyrController.document.toPlainText().contains(RegExp(r'\S+'))) {
            snacker(context, '请填写文章内容');
            return;
          }

          if (update != true) {
            toPreview();
            return;
          }
          
          ///// refresh actions
          _bloc.dispatch(Refresh(edit: true));
          /////
          var res;
          if (args.community != null) {
            res = await r.updateReddit(document: json, id: args.id);
          } else {
            res = await r.updatePost(document: json, id: args.id);
          }
          
          ///// stop refreshing actions
          _bloc.dispatch(Refresh(edit: false));
          ////

          if (res.statusCode != 200) {
            snacker(context, '更新失败，请重试');
            return;
          }

          snacker(context, '更新成功', color: Colors.black);

          if (args.community != null) {
            _bloc.dispatch(RedditRefresh(refresh: true));
            _rbloc.dispatch(FetchReddits(refresh: true));
          } else {
            _bloc.dispatch(PostRefresh(refresh: true));
            _pbloc.dispatch(FetchPosts(refresh: true));
          }
          
          if (toPreview != null) toPreview();
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
  final bool update;
  final ArticleArgs args;
  final VoidCallback toEdit;
  final ZefyrController zefyrController;
  final ScreenshotController screenshotController;
  More({
      this.args,
      this.update,
      this.toEdit,
      this.screenshotController,
      this.zefyrController,
  });
  
  @override
  build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInited) {
          if (state.mail == args.mail || args.mail == null) {
            return EditActions(
              args: args,
              update: update,
              toEdit: toEdit,
              controller: screenshotController,
              zefyrController: zefyrController,
            );
          }
        }

        return SizedBox.shrink();
      }
    );
  }
}

class EditActions extends StatelessWidget {
  final bool update;
  final ScreenshotController controller;
  final VoidCallback toEdit;
  final ArticleArgs args;
  final ZefyrController zefyrController;
  EditActions({
      this.update,
      this.controller,
      this.toEdit,
      this.args,
      this.zefyrController
  });

  @override
  Widget build(BuildContext context) {
    final RefreshBloc _bloc = BlocProvider.of<RefreshBloc>(context);
    final RedditBloc _rbloc = BlocProvider.of<RedditBloc>(context);
    final PostBloc _pbloc = BlocProvider.of<PostBloc>(context);

    post() async {
      final xReq.Requests r = await xReq.Requests.init();
      final String json = jsonEncode(zefyrController.document);

      FocusScope.of(context).requestFocus(FocusNode());
      if (!zefyrController.document.toPlainText().contains(RegExp(r'\S+'))) {
        snacker(context, '请填写文章内容');
        return;
      }

      ///// refresh actions
      _bloc.dispatch(Refresh(edit: true));
      /////
      
      var res;
      if (args.community != null){
        res = await r.newReddit(
          document: json, community: args.community, type: args.type
        );
      } else {
        res = await r.newPost(document: json);
      }


      if (res.statusCode != 200) {
        snacker(context, '发布失败，请重试');
        return;
      }
      
      ///// stop refreshing
      _bloc.dispatch(Refresh(edit: false));
      /////
      
      if (args.community != null) {
        _bloc.dispatch(RedditRefresh(refresh: true));
        _rbloc.dispatch(FetchReddits(refresh: true));
      } else {
        _bloc.dispatch(PostRefresh(refresh: true));
        _pbloc.dispatch(FetchPosts(refresh: true));
      }

      Navigator.maybePop(context);
      Navigator.maybePop(context);
    }
    
    delete() async {
      final xReq.Requests r = await xReq.Requests.init();

      ///// refresh actions
      _bloc.dispatch(Refresh(edit: true));
      /////
      var res;
      if (args.community != null) {
        res = await r.deleteReddit(id: args.id);
      } else {
        res = await r.deletePost(id: args.id);
      }

      ///// refresh actions
      _bloc.dispatch(Refresh(edit: false));
      /////
      if (res.statusCode == 200) {
        if (args.community != null) {
          _bloc.dispatch(RedditRefresh(refresh: true));
          _rbloc.dispatch(FetchReddits(refresh: true));
        } else {
          _bloc.dispatch(PostRefresh(refresh: true));
          _pbloc.dispatch(FetchPosts(refresh: true));
        }
        
        Navigator.maybePop(context);
      } else {
        snacker(context, '删除失败，请重试');
      }
      
      Navigator.maybePop(context);
    }

    alertDelete(BuildContext ctx) {
      Navigator.pop(ctx);
      alert(
        context,
        title: '删除文章?',
        ok: Text('确定'),
        action: delete,
      );
    }

    alertPost(BuildContext ctx) {
      Navigator.pop(ctx);
      alert(
        context,
        title: '发布文章?',
        action: post,
      );
    } 

    share() async {
      Navigator.pop(context);
      File image = await controller.capture(pixelRatio: 1.5);
      String name = DateTime.now().toString();
      await Share.file(name, "$name.png", image.readAsBytesSync(), 'image/png');
    }
    
    return NoRipple(
      icon: Icon(Icons.more_horiz),
      onTap: () async {
        showCupertinoModalPopup(
          context: context,
          builder: (ctx) => update == true ? CupertinoActionSheet(
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
          ) : CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text('发布'),
                onPressed: () => alertPost(ctx)
              ),
              CupertinoActionSheetAction(
                child: Text('编辑'),
                onPressed: toEdit,
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('取消'),
              onPressed: () => Navigator.pop(context)
            )
          )
        );
      }
    );
  }
}
