import 'dart:convert';
import 'package:cdr_today/x/conf.dart';
import 'package:cdr_today/x/store.dart';
import 'package:http/http.dart' as http;

const Response = http.Response;
http.Response timeout = http.Response('timeout', 408);

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
    return await rGet("/a/$mail");
  }

  //@authVerify: POST '/a/{mail:string}'
  Future<http.Response> authVerify({String mail, String code}) async {
    final Map body = { 'code': code };
    var res = await rPost("/a/$mail", body: body);
    if (res.statusCode == 200) {
      setString('mail', mail);
      setString('code', code);
    }
    return res;
  }

  //@updateName: PUT '/u/{mail:string}/i/name'
  Future<http.Response> updateName({String name}) async {
    final Map body = {
      'name': name
    };
    var res = await rPut("/u/$mail/i/name", body: body);
    return res;
  }

  //@updateName: PUT '/u/{mail:string}/i/avatar'
  Future<http.Response> updateAvatar({String avatar}) async {
    final Map body = {
      'avatar': avatar
    };
    var res = await rPut("/u/$mail/i/avatar", body: body);
    return res;
  }

  //@newPost: POST '/u/{mail:string}/p'
  Future<http.Response> newPost({String document}) async {
    final Map body = {
      'document': document,
    };
    return await rPost("/u/$mail/post", body: body);
  }

  //@getPosts: GET '/u/{mail:string}/p'
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

  //@upload: POST '/u/{mail:string}/upload'
  Future<http.Response> upload({ String image }) async {
    final Map body = {
      'image': image
    };
    return await rPost("/u/$mail/upload", body: body);
  }
}
