import 'package:aldente/services/pocketbase/pocketbase_service.dart';
import 'package:pocketbase/pocketbase.dart';

class User {
  final String? id;
  final DateTime? created;
  final DateTime? updated;
  final String? collectionId;
  final String? collectionName;
  String? avatar;
  final String? email;
  final bool? emailVisibility;
  final String? name;
  final String? username;
  final bool? verified;
  final String? role; // Added role field
  String? token;

  User({
    required this.id,
    required this.created,
    required this.updated,
    required this.collectionId,
    required this.collectionName,
    required this.avatar,
    required this.email,
    required this.emailVisibility,
    required this.name,
    required this.username,
    required this.verified,
    required this.role, // Added role parameter
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      created: DateTime.tryParse(json["created"] ?? ""),
      updated: DateTime.tryParse(json["updated"] ?? ""),
      collectionId: json["collectionId"],
      collectionName: json["collectionName"],
      avatar: json["avatar"],
      email: json["email"],
      emailVisibility: json["emailVisibility"],
      name: json["name"],
      username: json["username"],
      verified: json["verified"],
      role: json["role"], // Initialize role from JSON
      token: json["token"],
    );
  }

  Uri? get profilePicUrl {
    if (avatar?.isNotEmpty ?? false) {
      return PocketbaseService.to.getFileUrl(
        RecordModel(
          id: id ?? "",
          collectionId: collectionId ?? "",
          collectionName: collectionName ?? "",
        ),
        avatar!,
      );
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "created": created?.toIso8601String(),
      "updated": updated?.toIso8601String(),
      "collectionId": collectionId,
      "collectionName": collectionName,
      "avatar": avatar,
      "email": email,
      "emailVisibility": emailVisibility,
      "name": name,
      "username": username,
      "verified": verified,
      "role": role, // Include role in JSON serialization
      "token": token,
    };
  }
}
