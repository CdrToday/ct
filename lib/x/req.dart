import 'dart:convert';
import 'package:cdr_today/x/conf.dart';
import 'package:cdr_today/x/store.dart';
import 'package:http/http.dart' as http;

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
  Future<http.Response> rGet(String url) async {
    return await http.get("$base$url", headers: headers);
  }

  Future<http.Response> rPut(String url, {Map body}) async {
    return await http.put("$base$url", headers: headers, body: json.encode(body));
  }
  
  Future<http.Response> rPost(String url, {Map body}) async {
    return await http.post("$base$url", headers: headers, body: json.encode(body));
  }

  Future<http.Response> rDelete(String url) async {
    return await http.delete("$base$url", headers: headers);
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

  //@newPost: POST '/u/{mail:string}/p'
  Future<http.Response> newPost({String title, String cover, String content}) async {
    final Map body = {
      'title': title,
      'cover': cover,
      'content': content,
    };
    return await rPost("/u/$mail/p", body: body);
  }

  //@getPosts: GET '/u/{mail:string}/p'
  Future<http.Response> getPost({int page}) async {
    return await rGet("/u/$mail/p?p=$page");
  }
  
  //@updatePost: PUT '/u/{mail:string}/p/update'
  Future<http.Response> updatePost({
      String id, String title, String cover, String content
  }) async {
    final Map body = {
      'title': title,
      'cover': cover,
      'content': content,
    };
    return await rPut("/u/$mail/p/$id", body: body);
  }

  //@deletePost: DELETE '/u/{mail:string}/p/delete'
  Future<http.Response> deletePost({ String id }) async {
    return await rDelete("/u/$mail/p/$id");
  }

  //@upload: POST '/u/{mail:string}/upload'
  Future<http.Response> upload({ String image }) async {
    final Map body = {
      'image': image
    };
    return await rPost("/u/$mail/upload", body: body);
  }
}
