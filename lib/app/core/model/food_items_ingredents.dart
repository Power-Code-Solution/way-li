import 'package:wayli/app/core/model/base_model.dart';
import 'package:wayli/app/core/model/ingredents.dart';
import 'package:wayli/app/core/model/users.dart';

class FoodItemsIngredents extends BaseModel {
  final int id;
  final int fkFoodItemId;
  final int fkIngredientsId;

  FoodItemsIngredents({
    required this.id,
    required this.fkIngredientsId,
    required this.fkFoodItemId,
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

  factory FoodItemsIngredents.fromJson(Map<String, dynamic> json) {
    return FoodItemsIngredents(
      id: json['id'],
      fkIngredientsId: json['fkIngredientsId'],
      fkFoodItemId: json['fkFoodItemId'],
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
      "fkFoodItemId": fkFoodItemId,
      "fkIngredientsId": fkIngredientsId,
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
    fkFoodItemId: $fkFoodItemId,
    active: $active,
    deleted: $deleted,
    createdBy: $createdBy
  }
  ''';
  }
}
