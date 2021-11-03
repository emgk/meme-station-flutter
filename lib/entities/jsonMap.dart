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
  String? folderId;
  String? imageUrl;
  List<User>? user;
  List<Save>? save;
  List<Like>? like;
  DateTime? createdAt;
  DateTime? updatedAt;

  Meme({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.tags,
    required this.folderId,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.save,
    required this.like,
  });

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      id: json["_id"],
      userId: json["userId"],
      title: json["title"],
      description: json["description"],
      tags: json["tags"],
      folderId: json["folderId"],
      imageUrl: json["imageUrl"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      user: List<User>.from((json["user"] ?? []).map((x) => User.fromJson(x))),
      save: List<Save>.from((json["saved"] ?? []).map((x) => Save.fromJson(x))),
      like: List<Like>.from((json["likes"] ?? []).map((x) => Like.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "tags": tags,
        "folderId": folderId,
        "imageUrl": imageUrl,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user": List<User>.from((user ?? []).map((x) => x.toJson())),
        "save": List<Save>.from((save ?? []).map((x) => x.toJson())),
        "like": List<Like>.from((like ?? []).map((x) => x.toJson())),
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
  List<Meme>? memes;
  List<Folder>? folders;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.password,
    required this.profilePicture,
    required this.gender,
    required this.city,
    required this.memes,
    required this.folders,
    required this.createdAt,
    required this.updatedAt,
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
      memes:
          List<Meme>.from((json["memes"] ?? []).map((x) => Meme.fromJson(x))),
      folders: List<Folder>.from(
          (json["folders"] ?? []).map((x) => Folder.fromJson(x))),
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
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
        "memes": List<Meme>.from((memes ?? []).map((x) => x.toJson())),
        "folders": List<Folder>.from((folders ?? []).map((x) => x.toJson())),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}

List<Folder> folderFromJson(String str) =>
    List<Folder>.from(json.decode(str).map((x) => Folder.fromJson(x)));

String folderJson(List<Folder> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Folder {
  Folder({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.memes,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String userId;
  String title;
  String description;
  String imageUrl;
  List<Meme>? memes;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Folder.fromJson(Map<String, dynamic> json) => Folder(
        id: json["_id"],
        userId: json["userId"],
        title: json["title"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        memes:
            List<Meme>.from((json["memes"] ?? []).map((x) => Meme.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
        "memes": List<Meme>.from((memes ?? []).map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

List<Folder> savesFromJson(String str) =>
    List<Folder>.from(json.decode(str).map((x) => Save.fromJson(x)));

String savesJson(List<Folder> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Save {
  Save({
    required this.id,
    required this.userId,
    required this.memeId,
    required this.folderId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String userId;
  String memeId;
  String folderId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Save.fromJson(Map<String, dynamic> json) => Save(
        id: json["_id"],
        userId: json["userId"],
        memeId: json["memeId"],
        folderId: json["folderId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "memeId": memeId,
        "folderId": folderId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

List<Folder> likesFromJson(String str) =>
    List<Folder>.from(json.decode(str).map((x) => Like.fromJson(x)));

String likeJson(List<Folder> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Like {
  Like({
    required this.id,
    required this.userId,
    required this.memeId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String userId;
  String memeId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        id: json["_id"],
        userId: json["userId"],
        memeId: json["memeId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "memeId": memeId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
