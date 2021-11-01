// ignore_for_file: file_names

import 'dart:convert';

List<Meme> MemeFromJson(String str) =>
    List<Meme>.from(json.decode(str).map((x) => Meme.fromJson(x)));

// String MemeToJson(List<Meme> data) =>
// json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Meme {
  String? id;
  String? userId;
  String? title;
  String? description;
  String? tags;
  int? folderId;
  String? imageUrl;

  Meme({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.tags,
    required this.folderId,
    required this.imageUrl,
  });

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      id: json["id"],
      userId: json["userId"],
      title: json["title"],
      description: json["description"],
      tags: json["tags"],
      folderId: json["folderId"],
      imageUrl: json["imageUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "tags": tags,
        "folderId": folderId,
        "imageUrl": imageUrl,
      };
}

List<User> UserFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String UserToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String? id;
  String? name;
  String? email;
  String? bio;
  String? password;
  String? profilePicture;
  String? gender;
  String? city;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.password,
    required this.profilePicture,
    required this.gender,
    required this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      bio: json["bio"],
      password: json["password"],
      profilePicture: json["profilePicture"],
      gender: json["gender"],
      city: json["city"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "bio": bio,
        "password": password,
        "profilePicture": profilePicture,
        "gender": gender,
        "city": city,
      };
}
