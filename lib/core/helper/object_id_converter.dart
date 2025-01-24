import 'package:json_annotation/json_annotation.dart';
import 'package:bson/bson.dart';

class ObjectIdConverter implements JsonConverter<ObjectId?, String?> {
  const ObjectIdConverter();

  @override
  ObjectId? fromJson(String? json) {
    if (json == null) return null;
    return ObjectId.parse(json);
  }

  @override
  String? toJson(ObjectId? objectId) {
    return objectId?.oid;
  }
}
