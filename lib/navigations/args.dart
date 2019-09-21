class RootArgs {
  final int index;
  final bool fetch;
  RootArgs({ this.index, this.fetch });
}

class ArticleArgs {
  final bool edit;
  final String id;
  final String document;
  final int timestamp;

  ArticleArgs({
      this.edit,
      this.id,
      this.document,
      this.timestamp
  });
}

class ModifyArgs {
  final String index;
  final String title;
  ModifyArgs({ this.index, this.title });
}

class NameArgs {
  final String name;
  NameArgs({ this.name });
}

class AuthorArgs {
  final String name;
  final String avatar;
  final String mail;
  AuthorArgs({ this.name, this.avatar, this.mail });
}

class CustomAvatarArgs {
  final bool rect;
  final String url;
  final String tag;
  final List<String> baks;
  CustomAvatarArgs({ this.url, this.tag, this.baks, this.rect });
}
