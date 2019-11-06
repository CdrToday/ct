import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cdr_today/widgets/cards.dart';
import 'package:cdr_today/navigations/args.dart';

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

    return WeChat(
      avatar: x.avatar,
      author: x.author,
      cover: cover,
      mail: x.mail,
      timestamp: x.timestamp,
      long: x.document.length > 80 ? true : false,
      title: title,
      onTap: () => Navigator.of(
        context, rootNavigator: true
      ).pushNamed('/article', arguments: x),
    );
  }
}
