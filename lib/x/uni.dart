import 'dart:async';
import 'dart:io';
import 'package:uni_links/uni_links.dart';

StreamSubscription _sub;

Future<Null> initUniLinks() async {
  // ... check initialLink

  // Attach a listener to the stream
  _sub = getLinksStream().listen((String link) {
      // Parse the link and warn the user, if it is not correct
      print(link);
    }, onError: (err) {
      print(err);
      // Handle exception by warning the user their action did not succeed
  });

  // NOTE: Don't forget to call _sub.cancel() in dispose()
}
