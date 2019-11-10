import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/x/req.dart' as xReq;

Future<List<dynamic>> getTopics({String id}) async {
  final xReq.Requests r = await xReq.Requests.init();
  var res = await r.getTopics(id);
  return jsonDecode(res.body)['topics'];
}

Future<List<dynamic>> getTopicBatch(String id, String topic) async {
  final xReq.Requests r = await xReq.Requests.init();
  var res = await r.getTopicBatch(id, topic);
  return jsonDecode(res.body)['reddits'];
}

// ------- bloc -----
class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final CommunityBloc c;
  
  TopicBloc({ this.c }) {
    c.state.listen((state) {
        if (state is Communities) {
          if (
            state.current != '' && state.current != null
          ) this.dispatch(FetchTopic(id: state.current));
        }
    });
  }
  
  @override
  Stream<TopicState> transform(
    Stream<TopicEvent> events,
    Stream<TopicState> Function(TopicEvent event) next,
  ) {
    return super.transform(
      (events as Observable<TopicEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next,
    );
  }
  
  @override
  TopicState get initialState => Topics(
    id: '',
    batch: [],
    topics: [],
    refresh: 0,
  );

  @override
  Stream<TopicState> mapEventToState(TopicEvent event) async* {
    if (event is FetchTopic) {
      var topics = await getTopics(id: event.id);
      yield (currentState as Topics).copyWith(
        id: event.id,
        topics: topics,
        refresh: (currentState as Topics).refresh + 1,
      );
    } else if (event is UpdateTopic) {
      var topics = await getTopics(id: (currentState as Topics).id);
      yield (currentState as Topics).copyWith(
        topics: topics,
        refresh: (currentState as Topics).refresh + 1,
      );
    } else if (event is BatchTopic) {
      var batch = await getTopicBatch((currentState as Topics).id, event.topic);
      yield (currentState as Topics).copyWith(
        batch: batch,
        refresh: (currentState as Topics).refresh + 1,
      );
    }
  }
}

// ------------- state ------------
abstract class TopicState extends Equatable {
  TopicState([List props = const []]) : super(props);
}

class Topics extends TopicState {
  final List<dynamic> topics;
  final List<dynamic> batch;
  final int refresh;
  final String id;
  
  Topics({
      this.id = '', this.topics, this.refresh = 0, this.batch
  }) : super([ id, topics, refresh, batch ]);

  Topics copyWith({
      List<dynamic> topics, List<dynamic> batch, int refresh, String id, 
  }) {
    return Topics(
      id: id ?? this.id,
      batch: batch ?? this.batch,
      topics: topics ?? this.topics,
      refresh: refresh ?? this.refresh
    );
  }
}

// ------------- events -------------
abstract class TopicEvent extends Equatable {}

class FetchTopic extends TopicEvent {
  final String id;
  FetchTopic({ this.id });
  
  @override
  toString() => "FetchTopic";
}

class BatchTopic extends TopicEvent {
  final String topic;
  BatchTopic({ this.topic });

  @override
  toString() => "BatchTopic";
}

class UpdateTopic extends TopicEvent {
  @override
  toString() => "UpdateTopic";
}
