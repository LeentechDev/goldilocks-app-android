import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.name,
    this.email,
    this.password,
    this.deviceToken,
    this.apiToken,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.googleId,
    this.facebookId,
    this.customFields,
    this.hasMedia,
    this.media,
  });

  String name;
  String email;
  String password;
  String deviceToken;
  String apiToken;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  String googleId;
  String facebookId;
  List<dynamic> customFields;
  bool hasMedia;
  List<dynamic> media;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json["name"],
    email: json["email"],
    password: json["password"],
    deviceToken: json["device_token"],
    apiToken: json["api_token"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    googleId: json["google_id"],
    facebookId: json["facebook_id"],
    customFields: List<dynamic>.from(json["custom_fields"].map((x) => x)),
    hasMedia: json["has_media"],
    media: List<dynamic>.from(json["media"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "device_token": deviceToken,
    "api_token": apiToken,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "google_id": googleId,
    "facebook_id": facebookId,
    "custom_fields": List<dynamic>.from(customFields.map((x) => x)),
    "has_media": hasMedia,
    "media": List<dynamic>.from(media.map((x) => x)),
  };
}
