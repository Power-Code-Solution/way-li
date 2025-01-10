import 'package:wayli/app/core/model/base_model.dart';

class FoodItemImage extends BaseModel{
  int id;
  int fkFoodItemId;
  String image;


FoodItemImage({
    required this.id,
    required this.fkFoodItemId,
    required this.image,
    required bool active,
    required bool deleted,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime deletedAt,
    String? deletedReason,
  }) : super(
          active: active,
          deleted: deleted,
          createdBy: createdBy,
          updatedBy: updatedBy,
          deletedBy: deletedBy,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
          deletedReason: deletedReason,
        );

  factory FoodItemImage.fromJson(Map<String, dynamic> json) => FoodItemImage(
        id: json["id"],
        fkFoodItemId: json["fkFoodItemId"],
        image: json["image"],
        active: json["active"],
        deleted: json["deleted"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        deletedBy: json["deletedBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: DateTime.parse(json["deletedAt"]),
        deletedReason: json["deletedreason"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fkFoodItemId": fkFoodItemId,
        "image": image,
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


@override
String toString() {
  return '''
  FoodItemImage {
    id: $id,
    fkFoodItemId: $fkFoodItemId,
    image: $image,
    createdAt: $createdAt,
    updatedAt: $updatedAt,
    deletedAt: $deletedAt,
  }
  ''';
}


}
