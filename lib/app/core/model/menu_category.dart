import 'package:wayli/app/core/model/base_model.dart';

class MenuCategory extends BaseModel {
  final int id;
  final int fkMenuId;
  final String? name;
  final String? description;
  final String? coverImage;
// Menu? menu;

  MenuCategory({
    required this.id,
    required this.fkMenuId,
    required this.name,
    required this.description,
    required this.coverImage,
    // this.menu,
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

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'],
      fkMenuId: json['fkMenuId'],
      name: json['name'],
      description: json['description'],
      coverImage: json['coverImage'],
      // menu: json["menu"] != null ? Menu.fromJson(json["menu"]) : null,
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
      "fkMenuId": fkMenuId,
      "name": name,
      "description": description,
      "coverImage": coverImage,
// "menu": menu!.toJson(),
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
    fkMenuId: $fkMenuId,
    name: $name,
    description: $description,
    coverImage: $coverImage,
   
  }
  ''';
  }
}
