import 'package:wayli/app/core/model/base_model.dart';

class Users extends BaseModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? password;
  final String phone;
  final String address;
  final DateTime lastConnect;
  final int fkCityId;
  final int fkCommunityId;
  final dynamic city;
  final dynamic community;
  final dynamic userPermissions;

  Users({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    required this.phone,
    required this.address,
    required this.lastConnect,
    required this.fkCityId,
    required this.fkCommunityId,
    this.city,
    this.community,
    this.userPermissions,
    required super.active,
    required super.deleted,
    super.createdBy,
    super.updatedBy,
    super.deletedBy,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
    super.deletedReason,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      address: json['address'],
      lastConnect: DateTime.parse(json['lastconnect']),
      fkCityId: json['fkCityId'],
      fkCommunityId: json['fkCommunityId'],
      city: json['city'],
      community: json['community'],
      userPermissions: json['userPermissions'],
      active: json['active'],
      deleted: json['deleted'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      deletedBy: json['deletedBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: DateTime.parse(json['deletedAt']),
      deletedReason: json['deletedreason'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "phone": phone,
      "address": address,
      "lastConnect": lastConnect,
      "fkCityId": fkCityId,
      "fkCommunityId": fkCommunityId,
      "city": city,
      "community": community,
      "userPermissions": userPermissions,
      "active": active,
      "deleted": deleted,
      "createdBy": createdBy,
      "updatedBy": updatedBy,
      "deletedBy": deletedBy,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "deletedAt": deletedAt.toIso8601String(),
      "deletedreason": deletedReason,
    };
  }

  @override
  String toString() {
    return '''
  Users {
    id: $id,
    firstName: $firstName,
    lastName: $lastName,
    email: $email,
    phone: $phone,
    address: $address,
    lastConnect: $lastConnect,
    address: $address,
    address: $address,
  }
  ''';
  }
}

class CreateUsers {
  final String firstName;
  final String lastName;
  final String email;
  final String? password;
  final String phone;
  final String address;
  final int fkCityId;
  final int fkCommunityId;

  CreateUsers({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    required this.phone,
    required this.address,
    required this.fkCityId,
    required this.fkCommunityId,
  });

  factory CreateUsers.fromJson(Map<String, dynamic> json) {
    return CreateUsers(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      address: json['address'],
      fkCityId: json['fkCityId'],
      fkCommunityId: json['fkCommunityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "phone": phone,
      "address": address,
      "fkCityId": fkCityId,
      "fkCommunityId": fkCommunityId,
    };
  }

  @override
  String toString() {
    return '''
  Users {
    firstName: $firstName,
    lastName: $lastName,
    email: $email,
    phone: $phone,
    address: $address,
    address: $address,
    address: $address,
  }
  ''';
  }
}
