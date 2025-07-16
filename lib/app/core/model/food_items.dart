import 'package:wayli/app/core/model/base_model.dart';
import 'package:wayli/app/core/model/foodItem_tag.dart';
import 'package:wayli/app/core/model/food_item_image.dart';
import 'package:wayli/app/core/model/menu.dart';
import 'package:wayli/app/core/model/menu_category.dart';
import 'package:wayli/app/core/model/review.dart';
class FoodResponse {
  List<FoodItem>? data;
  dynamic pages;
  dynamic pageIndex;
  int? status;
  String? message;

  FoodResponse({
    this.data,
    this.pages,
    this.pageIndex,
    this.status,
    this.message,
  });

  factory FoodResponse.fromJson(Map<String, dynamic> json) => FoodResponse(
    data: json["data"] == null
        ? null
        : List<FoodItem>.from(
        (json["data"] as List).map((x) => FoodItem.fromJson(x))),
    pages: json["pages"],
    pageIndex: json["pageIndex"],
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.map((x) => x.toJson()).toList(),
    "pages": pages,
    "pageIndex": pageIndex,
    "status": status,
    "message": message,
  };
}

class FoodItem extends BaseModel {
  int? id;
  int? fkMenuCategoryId;
  String? name;
  String? description;
  bool? isActive;
  String? imageUrl;
  String? type;
  double? servingSize;
  double? price;
  double? priceDouble;
  double? taxRate;
  MenuCategory? menuCategory;
  List<FoodItemImage>? foodItemsImages;

  FoodItem({
    this.id,
    this.fkMenuCategoryId,
    this.name,
    this.description,
    this.isActive,
    this.imageUrl,
    this.servingSize,
    this.type,
    this.price,
    this.priceDouble,
    this.taxRate,
    this.menuCategory,
    this.foodItemsImages,
    super.active,
    super.deleted,
    super.createdBy,
    super.updatedBy,
    super.deletedBy,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    super.deletedReason,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    id: json["id"],
    fkMenuCategoryId: json["fkMenuCategoryId"],
    name: json["name"],
    description: json["description"],
    isActive: json["isActive"],
    imageUrl: json["imageUrl"],
    servingSize: (json["servingSize"] as num?)?.toDouble(),
    type: json["type"],
    price: (json["price"] as num?)?.toDouble(),
    priceDouble: (json["priceDouble"] as num?)?.toDouble(),
    taxRate: (json["taxRate"] as num?)?.toDouble(),
    menuCategory: json["menuCategory"] == null
        ? null
        : MenuCategory.fromJson(json["menuCategory"]),
    foodItemsImages: json["foodItemsImages"] == null
        ? null
        : List<FoodItemImage>.from(
        (json["foodItemsImages"] as List)
            .map((x) => FoodItemImage.fromJson(x))),
    active: json["active"],
    deleted: json["deleted"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    deletedBy: json["deletedBy"],
    createdAt: json["createdAt"] != null
        ? DateTime.tryParse(json["createdAt"])
        : null,
    updatedAt: json["updatedAt"] != null
        ? DateTime.tryParse(json["updatedAt"])
        : null,
    deletedAt: json["deletedAt"] != null
        ? DateTime.tryParse(json["deletedAt"])
        : null,
    deletedReason: json["deletedreason"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "fkMenuCategoryId": fkMenuCategoryId,
    "name": name,
    "description": description,
    "isActive": isActive,
    "imageUrl": imageUrl,
    "servingSize": servingSize,
    "type": type,
    "price": price,
    "priceDouble": priceDouble,
    "taxRate": taxRate,
    "menuCategory": menuCategory?.toJson(),
    "foodItemsImages": foodItemsImages?.map((x) => x.toJson()).toList(),
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
// foodItemsTags: ${foodItemsTags.map((e) => e.toString()).join(', ')},
// review: ${review.map((e) => e.toString()).join(', ')},
