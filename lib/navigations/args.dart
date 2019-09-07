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
  final bool edit;
  final String id;
  final String title;
  final String cover;
  final String content;
  ArticleArgs({ this.edit, this.id, this.title, this.cover, this.content });
}

class ModifyArgs {
  final String index;
  final String title;
  ModifyArgs({ this.index, this.title });
}
