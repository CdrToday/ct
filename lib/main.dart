import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// blocs
import 'package:cdr_today/blocs/main.dart';
import 'package:cdr_today/blocs/auth.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/blocs/topic.dart';
import 'package:cdr_today/blocs/member.dart';
import 'package:cdr_today/blocs/reddit.dart';
import 'package:cdr_today/blocs/community.dart';
// pages
import 'package:cdr_today/pages/login.dart';
import 'package:cdr_today/pages/verify.dart';
import 'package:cdr_today/pages/edit.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/pages/protocol.dart';
import 'package:cdr_today/pages/article.dart';
import 'package:cdr_today/pages/version.dart';
import 'package:cdr_today/pages/splash.dart';
import 'package:cdr_today/pages/profile.dart';
import 'package:cdr_today/pages/avatar.dart';
import 'package:cdr_today/pages/bucket.dart';
import 'package:cdr_today/pages/scan.dart';
import 'package:cdr_today/pages/name.dart';
import 'package:cdr_today/pages/member.dart';
import 'package:cdr_today/pages/reddit.dart';
import 'package:cdr_today/pages/about.dart';
import 'package:cdr_today/pages/settings.dart';
import 'package:cdr_today/pages/qrcode.dart' as qr;
import 'package:cdr_today/pages/topic.dart' as topic;
import 'package:cdr_today/pages/community.dart' as community;
// navigations
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/navigations/init.dart';
import 'package:cdr_today/navigations/txs.dart';
// utils
import 'package:cdr_today/x/_style/theme.dart';

/* app */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

final VerifyBloc verifyBloc = VerifyBloc();
final PostBloc postBloc = PostBloc();
final UserBloc userBloc = UserBloc(v: verifyBloc);
final CommunityBloc communityBloc = CommunityBloc(u: userBloc);
final TopicBloc topicBloc = TopicBloc(c: communityBloc);
final RedditBloc redditBloc = RedditBloc(c: communityBloc);
final MemberBloc memberBloc = MemberBloc(
  c: communityBloc, u: userBloc, r: redditBloc
);
final RefreshBloc refreshBloc = RefreshBloc(
  c: communityBloc,
  r: redditBloc,
);

class App extends StatefulWidget {
  final bool dark;
  App({ this.dark });

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          builder: (context) => ThemeBloc()
        ),
        BlocProvider<RedditBloc>(
          builder: (context) => redditBloc
        ),
        BlocProvider<VerifyBloc>(
          builder: (context) => verifyBloc
        ),
        BlocProvider<PostBloc>(
          builder: (context) => postBloc
        ),
        BlocProvider<CommunityBloc>(
          builder: (context) => communityBloc
        ),
        BlocProvider<TopicBloc>(
          builder: (context) => topicBloc,
        ),
        BlocProvider<MemberBloc>(
          builder: (context) => memberBloc
        ),
        BlocProvider<RefreshBloc>(
          builder: (context) => refreshBloc,
        ),
        BlocProvider<UserBloc>(
          builder: (context) => userBloc,
        ),
      ],
      child: CupertinoApp(
        initialRoute: '/',
        onGenerateRoute: router,
        home: SplashPage(),
        debugShowCheckedModeBanner: false,
        theme: CtThemeData.gen(),
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
      )
    );
  }
}

/* app router */
Route router(settings) {
  String r = settings.name;
  if (r == '/init') {
    return FadeRoute(
      page: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return (state is UserInited) ? InitPage() : ProtocolPage(login: true);
        }
      )
    );
  } else if (r == '/splash') {
    return FadeRoute(page: SplashPage());
  } else if (r == '/reddits') {
    // final RedditArgs args = settings.arguments;
    return SlideRoute(page: RedditPage());
  } else if (r == '/login') {
    return FadeRoute(page: Login());
  } else if (r == '/root') {
    return FadeRoute(page: InitPage());
  } else if (r == '/scan') {
    return SlideRoute(page: Scan());
  } else if (r == '/post') {
    final PostArgs args = settings.arguments;
    return SlideRoute(page: PostPage(args: args));
  } else if (r == '/article') {
    final ArticleArgs args = settings.arguments;
    return FadeRoute(page: Article(args: args));
  } else if (r == '/qrcode') {
    final QrCodeArgs args = settings.arguments;
    return FadeRoute(page: qr.QrCode(args: args));
  } else if (r == '/protocol') {
    final ProtocolArgs args = settings.arguments;
    return FadeRoute(page: ProtocolPage(login: args.login));
  } else if (r == '/qrcode/join') {
    final QrCodeArgs args = settings.arguments;
    return SlideRoute(page: qr.Join(args: args));
  } else if (r == '/community/member') {
    return FadeRoute(page: MemberPage());
  } else if (r == '/community/topics') {
    return FadeRoute(page: topic.TopicList());
  } else if (r == '/community/topic/batch') {
    final BatchArgs args = settings.arguments;
    return SlideRoute(page: topic.TopicBatch(topic: args.topic));
  } else if (r == '/community/create') {
    return SlideRoute(page: community.Create());
  } else if (r == '/community/settings') {
    return SlideRoute(page: community.Settings());
  } else if (r == '/user/verify') {
    return SlideRoute(page: Verify());
  } else if (r == '/user/edit') {
    final ArticleArgs args = settings.arguments;
    return SlideRoute(page: Edit(args: args));
  } else if (r == '/mine/about') {
    return SlideRoute(page: About());
  } else if (r == '/mine/settings') {
    return SlideRoute(page: Settings());
  } else if (r == '/mine/bucket') {
    return SlideRoute(page: Bucket());
  } else if (r == '/mine/version') {
    return SlideRoute(page: VersionPage());
  } else if (r == '/mine/profile') {
    return SlideRoute(page: Profile(raw: true));
  } else if (r == '/mine/profile/avatar') {
    return FadeRoute(page: Avatar());
  } else if (r == '/mine/profile/name') {
    final NameArgs args = settings.arguments;
    return SlideRoute(page: Name(args: args));
  }
  
  return FadeRoute(page: VersionPage());
}
