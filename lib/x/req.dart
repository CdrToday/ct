import 'dart:convert';
import 'package:cdr_today/x/conf.dart';
import 'package:cdr_today/x/store.dart';
import 'package:http/http.dart' as http;

const Response = http.Response;
final http.Response timeout = http.Response('timeout', 408);

class Requests {
  final String base = conf['base'];
  String mail, code;
  Map<String, String> headers;

  // init
  static Future<Requests> init() async {
    String mail = await getString('mail');
    String code = await getString('code');
    Map<String, String> headers = {
      'code': code
    };

    return Requests(mail: mail, code: code, headers: headers);
  }
  
  Requests({this.mail, this.code, this.headers});
  
  // methods
  Future<http.Response> rGet(String url) {
    return http.get("$base$url", headers: headers).timeout(
      Duration(seconds: 10), onTimeout: () => timeout,
    );
  }

  Future<http.Response> rPut(String url, {Map body}) {
    return http.put("$base$url", headers: headers, body: json.encode(body)).timeout(
      Duration(seconds: 10), onTimeout: () => timeout,
    );
  }
  
  Future<http.Response> rPost(String url, {Map body}) {
    return http.post("$base$url", headers: headers, body: json.encode(body)).timeout(
      Duration(seconds: 10), onTimeout: () => timeout,
    );
  }

  Future<http.Response> rDelete(String url) {
    return http.delete("$base$url", headers: headers).timeout(
      Duration(seconds: 10), onTimeout: () => timeout,
    );
  }

  /* routes */
  //@auth: GET '/a/{mail:string}'
  Future<http.Response> auth({String mail}) async {
    return await rGet("/u/$mail");
  }

  //@authVerify: POST '/a/{mail:string}'
  Future<http.Response> authVerify({String mail, String code}) async {
    final Map body = { 'code': code };
    var res = await rPost("/u/$mail", body: body);
    if (res.statusCode == 200) {
      setString('mail', mail);
      setString('code', code);
    }
    return res;
  }

  /// --- reddit ---
  //@newReddit: POST '/u/{mail:string}/reddit'
  Future<http.Response> newReddit({String type, String community, String document}) async {
    final Map body = {
      'type': type,
      'document': document,
      'community': community,
    };
    return await rPost("/u/$mail/reddit", body: body);
  }

  //@getPosts: GET '/u/:mail/c/:id/reddit'
  Future<http.Response> getReddits({String community, int page}) async {
    var res = await rGet("/u/$mail/c/$community/reddit?p=$page");
    if (res.statusCode != 200) return getReddits(community: community, page: page);
    return res;
  }
  
  //@updatePost: PUT '/u/:mail/r/:id'
  Future<http.Response> updateReddit({
      String id, String document,
  }) async {
    final Map body = {
      'document': document,
    };
    return await rPut("/u/$mail/r/$id", body: body);
  }

  //@deletePost: DELETE '/u/:mail/p/delete'
  Future<http.Response> deleteReddit({ String id }) async {
    return await rDelete("/u/$mail/r/$id");
  }

  /// --- community ---
  //@getMembers GET '/u/{mail:string}/c'
  Future<http.Response> getCommunities() async {
    return await rGet("/u/$mail/c");
  }

  //@getMembers GET '/u/{mail:string}/{id:string}/members'
  Future<http.Response> getMembers({String id}) async {
    return await rGet("/u/$mail/c/$id/members");
  }

  //@getMembers GET '/u/{mail:string}/{id:string}/members'
  Future<http.Response> quitCommunity({String id}) async {
    return await rGet("/u/$mail/c/$id/quit");
  }

  //@createCommunity POST '/u/{mail:string}/c/create'
  Future<http.Response> createCommunity({String id, String name}) async {
    final Map body = {
      'id': id,
      'name': name
    };
    return await rPost("/u/$mail/c/create", body: body);
  }

  //@joinCommunity POST '/u/{mail:string}/c/join'
  Future<http.Response> joinCommunity({String id}) async {
    final Map body = {
      'id': id,
    };
    return await rPost("/u/$mail/c/join", body: body);
  }

  /// --- author ----
  //@getPosts: GET '/a/{mail:string}/post'
  Future<http.Response> getAuthorPost({int page, String mail}) async {
    return await rGet("/u/$mail/post?p=$page");
  }
  
  /// --- account ---
  //@updateName: PUT '/u/{mail:string}/i/name'
  Future<http.Response> updateName({String name}) async {
    final Map body = {
      'name': name
    };
    return await rPut("/u/$mail/i/name", body: body);
  }

  //@updateName: PUT '/u/{mail:string}/i/avatar'
  Future<http.Response> updateAvatar({String avatar}) async {
    final Map body = {
      'avatar': avatar,
    };
    return await rPut("/u/$mail/i/avatar", body: body);
  }

  /// --- post ---
  //@newPost: POST '/u/{mail:string}/p'
  Future<http.Response> newPost({String document}) async {
    final Map body = {
      'document': document,
    };
    return await rPost("/u/$mail/post", body: body);
  }

  //@getPosts: GET '/u/{mail:string}/post'
  Future<http.Response> getPost({int page}) async {
    return await rGet("/u/$mail/post?p=$page");
  }
  
  //@updatePost: PUT '/u/{mail:string}/p/update'
  Future<http.Response> updatePost({ String id, String document }) async {
    final Map body = {
      'document': document,
    };
    return await rPut("/u/$mail/post/$id", body: body);
  }

  //@deletePost: DELETE '/u/{mail:string}/p/delete'
  Future<http.Response> deletePost({ String id }) async {
    return await rDelete("/u/$mail/post/$id");
  }

  /// --- image ---
  //@upload: POST '/u/{mail:string}/upload'
  Future<http.Response> upload({ String image }) async {
    final Map body = {
      'image': image
    };
    return await rPost("/u/$mail/upload", body: body);
  }
}
