import 'package:json_annotation/json_annotation.dart';
import 'package:bson/bson.dart';

class ObjectIdConverter implements JsonConverter<ObjectId?, String?> {
  const ObjectIdConverter();

  @override
  ObjectId? fromJson(String? json) {
    return json != null ? ObjectId.parse(json) : null;
  }

  @override
  String? toJson(ObjectId? objectId) {
    return objectId?.toHexString();
  }
}
