import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cdr_today/blocs/db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/widgets/cards.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/x/_style/color.dart';
import 'package:cdr_today/widgets/tiles.dart';

/// ## type List
/// + article
class RedditItem extends StatelessWidget {
  final ArticleArgs x;
  RedditItem({ this.x });
  @override
  Widget build(BuildContext context) {
    List<dynamic> json = jsonDecode(x.document);
    String title;
    String cover;

    for (var i in json) {
      if (i['insert'].contains(RegExp(r'[\u4e00-\u9fa5_a-zA-Z0-9]'))) {
        if (title == null) {
          title = i['insert'].replaceAll(RegExp(r'\n'), '');
        }
      }

      if (
        cover == null
        && i['attributes'] != null
        && i['attributes']['embed'] != null
        && i['attributes']['embed']['type'] == 'image'
      ) {
        cover = i['attributes']['embed']['source'];
        continue;
      }
    }

    if (x.type == 'topic') {
      return TopicCard(
        title: title,
        onTap: () => Navigator.of(
          context, rootNavigator: true
        ).pushNamed(
          '/community/topic/batch',
          arguments: BatchArgs(topic: x.topic ?? x.id)
        )
      );
    }

    return BlocBuilder<DbBloc, DbState>(
      builder: (context, state) {
        if (x.type == 'reddit' && (state as Db).longArticle) {
          if (x.document.length <= 100) return SizedBox();
        }
        
        return WeChat(
          avatar: x.avatar,
          author: x.author,
          cover: cover,
          mail: x.mail,
          timestamp: x.timestamp,
          long: x.document.length > 100 ? true : false,
          title: title,
          ref: x.ref,
          onTap: () => Navigator.of(
            context, rootNavigator: true
          ).pushNamed('/article', arguments: x),
          onLongPress: () async {
            showModalBottomSheet(
              context: context,
              builder: (ctx) => Container(
                child: Wrap(
                  children: [
                    Container(
                      child: ListTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.reply, color: CtColors.primary, size: 22.0
                            ),
                            SizedBox(width: 10.0),
                            Text('回复文章', style: TextStyle(color: CtColors.primary)),
                          ]
                        ),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.of(
                            ctx, rootNavigator: true,
                          ).pushNamed(
                            '/user/edit',
                            arguments: ArticleArgs(
                              topic: (x.topic == null || x.topic == '') ? x.id : x.topic,
                              community: x.community,
                            ),
                          );
                        }
                      ),
                    ),
                    (x.topic == null || x.topic == '')?SizedBox.shrink():CtDivider(indent: 15.0),
                    (x.topic == null || x.topic == '')?SizedBox.shrink():Container(
                      child: ListTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.reply_all, color: CtColors.primary, size: 22.0
                            ),
                            SizedBox(width: 10.0),
                            Text('查看话题', style: TextStyle(color: CtColors.primary)),
                          ]
                        ),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.of(
                            ctx, rootNavigator: true,
                          ).pushNamed(
                            '/community/topic/batch',
                            arguments: BatchArgs(topic: x.topic)
                          );
                        }
                      ),
                    ),
                  ],
                ),
                color: CtColors.gray5,
              ),
            );
          }
        );
      }
    );
  }
}
