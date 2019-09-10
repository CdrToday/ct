import './conf.dart';
import './utils.dart';
import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

class ArticleListBloc extends Bloc<ArticleListEvent, ArticleListState> {
  @override
  ArticleListState get initialState => UnFetched();

  @override
  Stream<ArticleListState> mapEventToState(ArticleListEvent event) async* {
    if (event is FetchSelfArticles) {
      String mail = await getString('mail');
      var res = await http.get("${conf['url']}/$mail/articles");
      if (res.statusCode == 200) {
        ArticleListAPI articles = ArticleListAPI.fromJson(json.decode(res.body));
        if (articles.articles.length > 0) {
          yield FetchedSucceed(list: articles.articles);
        } else {
          yield EmptyList();
        }
      } else {
        yield FetchedFailed();
      }
      return;
    } else if (event is CleanList) {
      yield UnFetched();
    }
    return;
  }
}

// ----------- state -------------
abstract class ArticleListState extends Equatable {
  ArticleListState([List props = const []]) : super(props);
}

class UnFetched extends ArticleListState {
  @override
  String toString() => 'UnFetched';
}

class FetchedFailed extends ArticleListState {
  @override
  String toString() => 'FetchedFailed';
}

class FetchedSucceed extends ArticleListState {
  final dynamic list;
  FetchedSucceed({ this.list });
  @override
  String toString() => 'FetchedSucceed';
}

class EmptyList extends ArticleListState {
  @override
  String toString() => 'EmptyList';
}

// ----------- events ------------
abstract class ArticleListEvent extends Equatable {}

class FetchSelfArticles extends ArticleListEvent {
  @override
  String toString() => 'FetchSelfArticles';
}

class CleanList extends ArticleListEvent {
  @override
  String toString() => 'CleanList';
}

// ------------ api --------------
class ArticleListAPI {
  final List<dynamic> articles;
  ArticleListAPI({ this.articles });

  factory ArticleListAPI.fromJson(Map<String, dynamic> json) {
    return ArticleListAPI(articles: json['articles']);
  }
}
