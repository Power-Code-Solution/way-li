import 'package:wayli/app/core/model/base_model.dart';
import 'package:wayli/app/core/model/users.dart';

class Review extends BaseModel{
  final int id;
  final int fkFoodItemId;
  final int fkUserId;
  final Users users;
  final double rating;
  final String comment;


Review({
    required this.id,
    required this.fkFoodItemId,
    required this.fkUserId,
    required this.users,
    required this.rating,
    required this.comment,
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

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      fkFoodItemId: json['fkFoodItemId'],
      fkUserId: json['fkUserId'],
      users: Users.fromJson(json['users']),
      rating: json['rating'],
      comment: json['comment'],
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

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fkFoodItemId": fkFoodItemId,
      "fkUserId": fkUserId,
      "users": users.toJson(),
      "rating": rating,
      "comment": comment,
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
  Review {
    id: $id,
    fkFoodItemId: $fkFoodItemId,
    fkUserId: $fkUserId,
    users: $users,
    rating: $rating,
    comment: $comment,
  }
  ''';
}


}
