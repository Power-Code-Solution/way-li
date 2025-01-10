class UserModel {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? phone;
  final String? address;
  final int? fkCityId;
  final int? fkCommunityId;
  final DateTime? lastConnect;
  final bool? active;
  final bool? deleted;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? deletedReason;
  final String? city;
  final String? community;
  final List<dynamic>? userPermissions;

  UserModel({
     this.id,
     this.firstName,
     this.lastName,
     this.email,
     this.password,
     this.phone,
     this.address,
     this.fkCityId,
     this.fkCommunityId,
     this.lastConnect,
     this.active,
     this.deleted,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
     this.createdAt,
     this.updatedAt,
     this.deletedAt,
    this.deletedReason,
    this.city,
    this.community,
    this.userPermissions,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "phone": phone,
      "address": address,
      "fkCityId": fkCityId,
      "fkCommunityId": fkCommunityId,
      "lastConnect": lastConnect?.toIso8601String(),
      "active": active,
      "deleted": deleted,
      "createdBy": createdBy,
      "updatedBy": updatedBy,
      "deletedBy": deletedBy,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "deletedAt": deletedAt?.toIso8601String(),
      "deletedReason": deletedReason,
      "city": city,
      "community": community,
      "userPermissions": userPermissions,
    };
  }
}
