import './conf.dart';
import './utils.dart';
import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

// ------------ bloc -------------
class ArticleListBloc extends Bloc<ArticleListEvent, ArticleListState> {
  @override
  ArticleListState get initialState => UnFetched();

  @override
  Stream<ArticleListState> mapEventToState(ArticleListEvent event) async* {
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

// ----------- events ------------
abstract class ArticleListEvent extends Equatable {}

class FetchArticles extends ArticleListEvent {
  final String mail;
  FetchArticles({ this.mail });
}
