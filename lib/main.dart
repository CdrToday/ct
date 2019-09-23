import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// blocs
import 'package:cdr_today/blocs/main.dart';
import 'package:cdr_today/blocs/auth.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/profile.dart';
import 'package:cdr_today/blocs/member.dart';
import 'package:cdr_today/blocs/drawer.dart';
import 'package:cdr_today/blocs/reddit.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/blocs/_author.dart';
// pages
import 'package:cdr_today/pages/login.dart';
import 'package:cdr_today/pages/verify.dart';
import 'package:cdr_today/pages/edit.dart';
import 'package:cdr_today/pages/article.dart';
import 'package:cdr_today/pages/version.dart';
import 'package:cdr_today/pages/splash.dart';
import 'package:cdr_today/pages/profile.dart';
import 'package:cdr_today/pages/avatar.dart';
import 'package:cdr_today/pages/bucket.dart';
import 'package:cdr_today/pages/scan.dart';
import 'package:cdr_today/pages/name.dart';
import 'package:cdr_today/pages/author.dart';
import 'package:cdr_today/pages/raise.dart';
import 'package:cdr_today/pages/community.dart' as community;
// navigations
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/navigations/init.dart';
import 'package:cdr_today/navigations/txs.dart';

/* app */
void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

final VerifyBloc verifyBloc = VerifyBloc();
final ProfileBloc profileBloc = ProfileBloc();
final AuthorPostBloc authorPostBloc = AuthorPostBloc();
final UserBloc userBloc = UserBloc(v: verifyBloc, p: profileBloc);
final PostBloc postBloc = PostBloc(u: userBloc);
final CommunityBloc communityBloc = CommunityBloc(u: userBloc);
final MemberBloc memberBloc = MemberBloc(c: communityBloc);
final RedditBloc redditBloc = RedditBloc(c: communityBloc);
final RefreshBloc refreshBloc = RefreshBloc(
  p: postBloc,
  c: communityBloc,
  r: redditBloc,
);
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          builder: (context) => ThemeBloc()
        ),
        BlocProvider<PostBloc>(
          builder: (context) => postBloc
        ),
        BlocProvider<RedditBloc>(
          builder: (context) => redditBloc
        ),
        BlocProvider<VerifyBloc>(
          builder: (context) => verifyBloc
        ),
        BlocProvider<ProfileBloc>(
          builder: (context) => profileBloc
        ),
        BlocProvider<CommunityBloc>(
          builder: (context) => communityBloc
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
        BlocProvider<DrawerBloc>(
          builder: (context) => DrawerBloc(c: communityBloc),
        ),
        BlocProvider<AuthorPostBloc>(
          builder: (context) => AuthorPostBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, theme) => app(context, theme)
      )
    );
  }
}

Widget app(BuildContext context, ThemeData theme) {  
  return MaterialApp(
    theme: light(),
    initialRoute: '/',
    onGenerateRoute: router,
    home: SplashPage(),
    debugShowCheckedModeBanner: false
  );
}

/* app router */
Route router(settings) {
  String r = settings.name;
  if (r == '/init') {
    return FadeRoute(
      page: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserInited) {
            return InitPage();
          }
          return Login();
        }
      )
    );
  } else if (r == '/root') {
    return FadeRoute(page: InitPage());
  } else if (r == '/scan') {
    return FadeRoute(page: Scan());
  } else if (r == '/avatar') {
    final CustomAvatarArgs args = settings.arguments;
    return FadeRoute(page: CustomAvatar(args: args));
  } else if (r == '/article') {
    final ArticleArgs args = settings.arguments;
    return FadeRoute(page: Article(args: args));
  } else if (r == '/community/author') {
    final AuthorArgs args = settings.arguments;
    return FadeRoute(page: Author(args: args));
  } else if (r == '/community/raise') {
    return FadeRoute(page: Raise());
  } else if (r == '/community/create') {
    return FadeRoute(page: community.Create());
  } else if (r == '/community/join') {
    return FadeRoute(page: community.Join());
  } else if (r == '/community/settings') {
    return FadeRoute(page: community.Settings());
  } else if (r == '/user/verify') {
    return FadeRoute(page: Verify());
  } else if (r == '/user/edit') {
    final ArticleArgs args = settings.arguments;
    return FadeRoute(page: Edit(args: args));
  } else if (r == '/mine/bucket') {
    return FadeRoute(page: Bucket());
  } else if (r == '/mine/version') {
    return FadeRoute(page: VersionPage());
  } else if (r == '/mine/profile') {
    return FadeRoute(page: Profile());
  } else if (r == '/mine/profile/avatar') {
    return FadeRoute(page: Avatar());
  } else if (r == '/mine/profile/name') {
    final NameArgs args = settings.arguments;
    return FadeRoute(page: Name(args: args));
  }
  
  return MaterialPageRoute(
    builder: (context) =>  Center(child: Text('BUG'))
  );
}
