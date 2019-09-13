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
