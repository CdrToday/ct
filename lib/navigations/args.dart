class RootArgs {
  final int index;
  final bool fetch;
  RootArgs({ this.index, this.fetch });
}

class MailArgs {
  final String mail;
  MailArgs({ this.mail });
}

class ArticleArgs {
  final String id;
  final String title;
  final String content;
  ArticleArgs({ this.id, this.title, this.content });
}

class ModifyArgs {
  final String index;
  final String title;
  ModifyArgs({ this.index, this.title });
}
