import 'dart:convert';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/x/store.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/reddit.dart';
import 'package:cdr_today/blocs/topic.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/x/req.dart' as xReq;
import 'package:cdr_today/navigations/args.dart';
import 'package:screenshot/screenshot.dart';

class EditAction extends StatelessWidget {
  final BuildContext ctx;
  EditAction(this.ctx);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        return CtNoRipple(
          icon: Icons.edit,
          size: 20.0,
          onTap: () async {
            Navigator.of(
              context, rootNavigator: true
            ).pushNamed(
              '/user/edit',
              arguments: ArticleArgs(community: (state as Communities).current)
            );
          }
        );
      }
    );
  }
}

class Update extends StatelessWidget {
  final bool update;
  final ArticleArgs args;
  final ZefyrController zefyrController;
  final VoidCallback toPreview;
  Update({ this.update, this.zefyrController, this.args, this.toPreview });

  @override
  Widget build(BuildContext context) {
    final RefreshBloc _bloc = BlocProvider.of<RefreshBloc>(context);
    final RedditBloc _rbloc = BlocProvider.of<RedditBloc>(context);
    final TopicBloc _tbloc = BlocProvider.of<TopicBloc>(context);
    
    return Builder(
      builder: (context) => EditRefresher(
        widget: CtNoRipple(
          icon: Icons.check,
          onTap: () async {
            final xReq.Requests r = await xReq.Requests.init();
            final String json = jsonEncode(zefyrController.document);

            FocusScope.of(context).requestFocus(FocusNode());
            if (!zefyrController.document.toPlainText().contains(RegExp(r'\S+'))) {
              info(context, '请填写文章内容');
              return;
            }

            ///// refresh actions
            _bloc.dispatch(Refresh(edit: true));
            /////

            var res;
            res = await r.updateReddit(document: json, id: args.id);
            
            if (res.statusCode != 200) {
              info(context, '更新失败，请重试');
              _bloc.dispatch(Refresh(edit: false));
              return;
            }

            _bloc.dispatch(Refresh(edit: false));
            _rbloc.dispatch(FetchReddits(refresh: true));
            _tbloc.dispatch(BatchTopic(topic: args.topic));
            
            if (toPreview != null) toPreview();
          }
        )
      )
    );
  }
}

class More extends StatelessWidget {
  final bool update;
  final ArticleArgs args;
  final VoidCallback toEdit;
  final ZefyrController zefyrController;
  final ScreenshotController screenshotController;
  final BuildContext sContext;
  More({
      this.args,
      this.update,
      this.toEdit,
      this.sContext,
      this.screenshotController,
      this.zefyrController,
  });
  
  @override
  build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInited) {
          if (state.mail == args.mail || args.mail == null) {
            return EditRefresher(
              widget: EditActions(
                args: args,
                update: update,
                toEdit: toEdit,
                sContext: sContext,
                controller: screenshotController,
                zefyrController: zefyrController,
              )
            );
          }
        }

        return SizedBox.shrink();
      }
    );
  }
}

class Publish extends StatelessWidget {
  final ArticleArgs args;
  final BuildContext sContext;
  final ZefyrController zefyrController;
  
  Publish({
      this.args,
      this.sContext,
      this.zefyrController
  });

  didChangeDependencies() {
    // inheritFromWidgetOfExactType();
  }
  
  @override
  Widget build(BuildContext context) {
    final RefreshBloc _bloc = BlocProvider.of<RefreshBloc>(context);
    final RedditBloc _rbloc = BlocProvider.of<RedditBloc>(context);
    final TopicBloc _tbloc = BlocProvider.of<TopicBloc>(context);

    post() async {
      final xReq.Requests r = await xReq.Requests.init();
      final String json = jsonEncode(zefyrController.document);
      FocusScope.of(context).requestFocus(FocusNode());
      if (!zefyrController.document.toPlainText().contains(RegExp(r'\S+'))) {
        info(context, '请填写文章内容');
        return;
      }

      ///// refresh actions
      _bloc.dispatch(Refresh(edit: true));
      /////

      var res = await r.newReddit(
        document: json,
        type: args.type,
        topic: args.topic,
        community: args.community,
      );

      if (res.statusCode != 200) {
        _bloc.dispatch(Refresh(edit: false));
        info(sContext, '发布失败，请重试');
        return;
      }

      setString('_article', '');
      _rbloc.dispatch(FetchReddits(refresh: true));
      _tbloc.dispatch(UpdateTopic());
      _tbloc.dispatch(BatchTopic(topic: args.topic));

      Navigator.maybePop(sContext);
    }

    return CtNoRipple(
      icon: Icons.check,
      onTap: post
    );
  }
}

class EditActions extends StatelessWidget {
  final bool update;
  final ScreenshotController controller;
  final VoidCallback toEdit;
  final ArticleArgs args;
  final ZefyrController zefyrController;
  final BuildContext sContext;
  EditActions({
      this.update,
      this.controller,
      this.toEdit,
      this.args,
      this.sContext,
      this.zefyrController
  });

  @override
  Widget build(BuildContext context) {
    final RefreshBloc _bloc = BlocProvider.of<RefreshBloc>(context);
    final RedditBloc _rbloc = BlocProvider.of<RedditBloc>(context);
    final TopicBloc _tbloc = BlocProvider.of<TopicBloc>(context);
    
    toTop() async {
      Navigator.maybePop(context);
      final xReq.Requests r = await xReq.Requests.init();
      _bloc.dispatch(Refresh(edit: true));
       
      var res = await r.updateRedditTime(id: args.id);
      if (res.statusCode == 200) {
        _rbloc.dispatch(FetchReddits(refresh: true));
        _tbloc.dispatch(BatchTopic(topic: args.topic ?? args.id));
        
        Navigator.maybePop(sContext);
      } else {
        _bloc.dispatch(Refresh(edit: false));
        info(sContext, '置顶失败，请重试');
        return;
      }
    }
    
    delete() async {
      Navigator.maybePop(context);
      final xReq.Requests r = await xReq.Requests.init();
      _bloc.dispatch(Refresh(edit: true));

      var res = await r.deleteReddit(id: args.id);

      if (res.statusCode == 200) {
        Navigator.maybePop(sContext);
        
        _rbloc.dispatch(FetchReddits(refresh: true));
        _tbloc.dispatch(BatchTopic(topic: args.topic ?? args.id));
      } else {
        _bloc.dispatch(Refresh(edit: false));
        info(sContext, '删除失败，请重试');
        return;
      }
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

    return CtNoRipple(
      icon: Icons.more_horiz,
      onTap: () async {
        showCupertinoModalPopup(
          context: context,
          builder: (ctx) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text('置顶'),
                onPressed: toTop,
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
