class ArticleArgs {
  final bool edit;
  final bool batch;
  final String id;
  final String ref;
  final String type;
  final String mail;
  final String avatar;
  final String author;
  final String document;
  final String community;
  final String topic;
  final int timestamp;

  ArticleArgs({
      this.id,
      this.ref,
      this.mail,
      this.edit,
      this.type,
      this.batch,
      this.topic,
      this.avatar,
      this.author,
      this.document,
      this.community,
      this.timestamp,
  });
}


class NameArgs {
  final String id;
  final String name;
  final String profile;
  final String idTarget;
  NameArgs({ this.name, this.id = '', this.profile = 'name', this.idTarget });
}

class CustomAvatarArgs {
  final bool rect;
  final String url;
  final String tag;
  final List<String> baks;
  CustomAvatarArgs({ this.url, this.tag, this.baks, this.rect });
}

enum QrType {
  community,
  join
}

class QrCodeArgs {
  final String code;
  final String name;
  final QrType type;

  QrCodeArgs({
      this.code,
      this.name,
      this.type,
  });
}

class BatchArgs {
  final String topic;
  BatchArgs({ this.topic });
}

class PostArgs {
  final String ident;
  final String community;
  PostArgs({ this.ident, this.community });
}

class ProtocolArgs {
  final bool login;
  ProtocolArgs({ this.login });
}
