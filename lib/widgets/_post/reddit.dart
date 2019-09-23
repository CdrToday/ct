import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cdr_today/x/time.dart';
import 'package:cdr_today/widgets/cards.dart';
import 'package:cdr_today/widgets/avatar.dart';
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
      if (i['insert'].contains(new RegExp(r'\S'))) {
        if (title == null) {
          title = i['insert'].replaceAll(RegExp(r'\s'), '');;
          continue;
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
      timestamp: x.timestamp,
      title: title,
      onTap: () {
        if (x.edit == true) {
          Navigator.pushNamed(context, '/user/edit', arguments: x);
        } else {
          Navigator.pushNamed(context, '/article', arguments: x);
        }
      }
    );
  }
}
