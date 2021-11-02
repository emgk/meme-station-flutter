import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/util/secure_storage.dart';

class APIService {
  // dio service instance
  static Dio dio = Dio();

  // endpoint base url
  static String baseUrl = "https://meme-station-api.herokuapp.com";

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // get access token form storage
  static Future getAccessToken() async {
    return await UserSecureStorage.getAccessToken() ?? '';
  }

  // remove access token form storage
  static Future removeAccessToken() async {
    return await UserSecureStorage.setAccessToken('');
  }

  static Future register(
    Map<String, dynamic> data,
  ) async {
    String url = "$baseUrl/user-register";

    try {
      var userData = json.encode(data);
      Response response = await dio.post(
        url,
        data: userData,
      );

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future saveMeme(
    Map<String, dynamic> data,
  ) async {
    String url = "$baseUrl/save";

    try {
      var userData = json.encode(data);

      // get access token
      String token = await getAccessToken();

      final response = await dio.post(
        url,
        data: userData,
        options: Options(
          headers: {
            "accept": "*/*",
            "Authorization": "Bearer $token",
          },
        ),
      );

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  // register user
  static Future login(String email, String password) async {
    String url = "$baseUrl/user-login";

    try {
      var payload = {"email": email, "password": password};

      Response response = await dio.post(
        url,
        data: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        var apiResponJson = json.decode(jsonEncode(response.data));
        // store in storage
        await UserSecureStorage.setAccessToken(apiResponJson['accessToken']);
      }

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<User> getLoggedUser() async {
    String url = "$baseUrl/user-current";

    try {
      // get access token
      String token = await getAccessToken();

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      var apiResponJson = json.decode(jsonEncode(response.data));
      return User.fromJson(apiResponJson);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> logout(Function callback) async {
    await removeAccessToken();
    callback();
  }

  static Future<List<Meme>> getSavedPosts(
    Map<String, dynamic> params,
  ) async {
    String url = "$baseUrl/memes/saved";

    try {
      // get access token
      String token = await getAccessToken();

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        var apiResponJson = json.decode(jsonEncode(response.data));
        List<Meme> memes = [];

        for (var prod in apiResponJson) {
          memes.add(Meme.fromJson(prod));
        }

        return memes;
      } else {
        throw Exception('Failed!');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  static Future<List<Meme>> getMemes(
    Map<String, dynamic> params,
  ) async {
    String url = "$baseUrl/memes";

    try {
      // get access token
      String token = await getAccessToken();

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        var apiResponJson = json.decode(jsonEncode(response.data));
        List<Meme> memes = [];

        for (var prod in apiResponJson) {
          memes.add(Meme.fromJson(prod));
        }

        return memes;
      } else {
        throw Exception('Failed!');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  // post new meme
  static Future postMeme(
    Map<String, dynamic> data,
    dynamic file,
  ) async {
    String url = "$baseUrl/memes";

    try {
      // get the file name
      String filename = file.path.split('/').last;

      // build form data
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          file.path,
          filename: filename,
          contentType: MediaType('image', 'jpg'),
        ),
        "type": "image/jpg",
        "title": data['title'],
        "description": data['description'],
        "folderId": data['folderId'],
        "userId": data['userId'],
      });

      // get access token
      String token = await getAccessToken();

      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            "accept": "*/*",
            // "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token",
          },
        ),
      );

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}
