import 'package:wayli/app/core/model/base_model.dart';

class FoodandTagDto {
  final int foodItemId;
  final String tagName;

  FoodandTagDto({
    required this.foodItemId,
    required this.tagName,
  });

  factory FoodandTagDto.fromJson(Map<String, dynamic> json) {
    return FoodandTagDto(
      foodItemId: json['foodItemId'],
      tagName: json['tagName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foodItemId": foodItemId,
      "tagName": tagName,
    };
  }

  @override
  String toString() {
    return '''
  FoodandTagDto {
    foodItemId: $foodItemId,
    tagName: $tagName,
  }
  ''';
  }
}

class FoodandAllergensDto {
  final int foodItemId;
  final String allergensName;

  FoodandAllergensDto({
    required this.foodItemId,
    required this.allergensName,
  });

  factory FoodandAllergensDto.fromJson(Map<String, dynamic> json) {
    return FoodandAllergensDto(
      foodItemId: json['foodItemId'],
      allergensName: json['allergensName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foodItemId": foodItemId,
      "allergensName": allergensName,
    };
  }

  @override
  String toString() {
    return '''
  FoodandAllergensDto {
    foodItemId: $foodItemId,
    allergensName: $allergensName,
  }
  ''';
  }
}

class FoodandIngredIentNameDto {
  final int foodItemId;
  final String ingredientName;

  FoodandIngredIentNameDto({
    required this.foodItemId,
    required this.ingredientName,
  });

  factory FoodandIngredIentNameDto.fromJson(Map<String, dynamic> json) {
    return FoodandIngredIentNameDto(
      foodItemId: json['foodItemId'],
      ingredientName: json['ingredientName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foodItemId": foodItemId,
      "ingredientName": ingredientName,
    };
  }

  @override
  String toString() {
    return '''
  FoodandIngredientNameDto {
    foodItemId: $foodItemId,
    ingredientName: $ingredientName,
  }
  ''';
  }
}
