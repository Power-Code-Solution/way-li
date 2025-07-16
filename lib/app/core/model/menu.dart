import 'package:wayli/app/core/model/base_model.dart';
import 'package:wayli/app/core/model/users.dart';

class Menu extends BaseModel {
  final int id;
  final String name;
  final String description;
  final String coverImage;

  Menu({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImage,
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

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      coverImage: json['coverImage'],
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
      "description": description,
      "coverImage": coverImage,
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
  Menu {
    id: $id,
    name: $name,
    description: $description,
    coverImage: $coverImage
  }
  ''';
  }
}
