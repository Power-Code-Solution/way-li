abstract class BaseModel {
  final bool active;
  final bool deleted;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;
  final String? deletedReason;

  BaseModel({
    required this.active,
    required this.deleted,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    this.deletedReason,
  });

  Map<String, dynamic> toJson() {
    return {
      "active": active,
      "deleted": deleted,
      "createdBy": createdBy,
      "updatedBy": updatedBy,
      "deletedBy": deletedBy,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "deletedAt": deletedAt.toIso8601String(),
      "deletedReason": deletedReason,
    };
  }

@override
String toString() {
  return '''
  BaseModel {
    Active: $active,
    Deleted: $deleted,
    CreatedBy: $createdBy,
    UpdatedBy: $updatedBy,
    DeletedBy: $deletedBy,
    createdAt: $createdAt,
    updatedAt: $updatedAt,
    deletedAt: $deletedAt,
    DeletedReason: $deletedReason,
  }
  ''';
}

}
