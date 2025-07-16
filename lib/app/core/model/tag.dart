import 'package:wayli/app/core/model/base_model.dart';

class Tag extends BaseModel {
  final int id;
  final String name;

  Tag({
    required this.id,
    required this.name,
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

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
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
      "name": name,
      "active": active,
      "deleted": deleted,
      "createdBy": createdBy,
      "updatedBy": updatedBy,
      "deletedBy": deletedBy,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "deletedAt": deletedAt?.toIso8601String(),
      "deletedreason": deletedReason,
    };
  }

  @override
  String toString() {
    return '''
  FoodItemsTags {
    id: $id,
    name: $name,
  }
  ''';
  }
}
