import 'package:wayli/app/core/model/base_model.dart';
import 'package:wayli/app/core/model/foodItem_tag.dart';
import 'package:wayli/app/core/model/food_item_image.dart';
import 'package:wayli/app/core/model/menu.dart';
import 'package:wayli/app/core/model/menu_category.dart';
import 'package:wayli/app/core/model/review.dart';

class FoodResponse {
  List<FoodItem> data;
  dynamic pages;
  dynamic pageIndex;
  int status;
  String message;
  FoodResponse({
    required this.data,
    this.pages,
    this.pageIndex,
    required this.status,
    required this.message,
  });

  factory FoodResponse.fromJson(Map<String, dynamic> json) => FoodResponse(
        data:
            List<FoodItem>.from(json["data"].map((x) => FoodItem.fromJson(x))),
        pages: json["pages"],
        pageIndex: json["pageIndex"],
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pages": pages,
        "pageIndex": pageIndex,
        "status": status,
        "message": message,
      };
}

class FoodItem extends BaseModel {
  int id;
  int fkMenuCategoryId;
  String name;
  String description;
  bool isActive;
  String? imageUrl;
  String type;
  // dynamic tags;
  double servingSize;
  double price;
  double priceDouble;
  double taxRate;
  MenuCategory menuCategory;
  // Menu menu;
  List<FoodItemImage> foodItemsImages;
  // List<FoodItemsTags>? foodItemsTags;
  // List<Review>? review;

  FoodItem({
    required this.id,
    required this.fkMenuCategoryId,
    required this.name,
    required this.description,
    required this.isActive,
    this.imageUrl,
    required this.servingSize,
    required this.type,
    // this.tags,
    required this.price,
    required this.priceDouble,
    required this.taxRate,
    required this.menuCategory,
    // required this.menu,
    required this.foodItemsImages,
    // this.foodItemsTags,
    // this.review,
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

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json["id"],
        fkMenuCategoryId: json["fkMenuCategoryId"],
        name: json["name"],
        description: json["description"],
        isActive: json["isActive"],
        imageUrl: json["imageUrl"],
        servingSize: json["servingSize"],
        type: json["type"],
        // tags: json["tags"],
        price: json["price"],
        priceDouble: json["priceDouble"],
        taxRate: json["taxRate"],
        menuCategory: MenuCategory.fromJson(json["menuCategory"]),
        // menu: Menu.fromJson(json["menu"]),
        foodItemsImages: List<FoodItemImage>.from(
            json["foodItemsImages"].map((x) => FoodItemImage.fromJson(x))),
        // foodItemsTags: List<FoodItemsTags>.from(
        //     json["foodItemsTags"].map((x) => FoodItemsTags.fromJson(x))),
        // review: List<Review>.from(json["review"].map((x) => Review.fromJson(x))),

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

  @override
  Map<String, dynamic> toJson() => {
        // "tags": tags,
        // "foodItemsTags": foodItemsTags != null ? List<dynamic>.from(foodItemsTags!.map((x) => x.toJson())) : [], // Default to empty list
        // "review": review != null ? List<dynamic>.from(review!.map((x) => x.toJson())) : [],
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
        "menuCategory": menuCategory.toJson(),
        // "menu": menu.toJson(),
        "foodItemsImages":
            List<dynamic>.from(foodItemsImages.map((x) => x.toJson())),
        // "foodItemsTags": List<dynamic>.from(foodItemsTags.map((x) => x.toJson())),
        // "review": List<dynamic>.from(review.map((x) => x.toJson())),
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
  FoodItem {
    id: $id,
    fkMenuCategoryId: $fkMenuCategoryId,
    name: $name,
    description: $description,
    isActive: $isActive,
    imageUrl: $imageUrl,
    servingSize: $servingSize,
    type: $type,
    price: $price,
    priceDouble: $priceDouble,
    taxRate: $taxRate,
 menuCategory: $menuCategory, 
    foodItemsImages: ${foodItemsImages.map((e) => e.toString()).join(', ')},
    createdAt: $createdAt,
    updatedAt: $updatedAt,
    deletedAt: $deletedAt,
  }
  ''';
  }
}

// foodItemsTags: ${foodItemsTags.map((e) => e.toString()).join(', ')},
// review: ${review.map((e) => e.toString()).join(', ')},
