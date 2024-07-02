import 'package:intl/intl.dart';

class Client {
  final String id;
  final String collectionId;
  final String collectionName;
  final DateTime created;
  final DateTime updated;
  final String userId;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime dateOfBirth;
  final String address;
  final String phoneNumber;

  Client({
    required this.id,
    required this.collectionId,
    required this.collectionName,
    required this.created,
    required this.updated,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
    required this.phoneNumber,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      collectionId: json['collectionId'],
      collectionName: json['collectionName'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      address: json['address'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat("yyyy-MM-dd HH:mm:ss.SSSZ");
    return {
      'id': id,
      'collectionId': collectionId,
      'collectionName': collectionName,
      'created': formatter.format(created),
      'updated': formatter.format(updated),
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'date_of_birth': formatter.format(dateOfBirth),
      'address': address,
      'phone_number': phoneNumber,
    };
  }
}

class ClientList {
  final int page;
  final int perPage;
  final int totalPages;
  final int totalItems;
  final List<Client> items;

  ClientList({
    required this.page,
    required this.perPage,
    required this.totalPages,
    required this.totalItems,
    required this.items,
  });

  factory ClientList.fromJson(Map<String, dynamic> json) {
    return ClientList(
      page: json['page'],
      perPage: json['perPage'],
      totalPages: json['totalPages'],
      totalItems: json['totalItems'],
      items: (json['items'] as List).map((item) => Client.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'perPage': perPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'items': items.map((client) => client.toJson()).toList(),
    };
  }
}