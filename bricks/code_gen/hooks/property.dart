import 'dart:convert';

class Property {
  const Property({
    required this.name,
    required this.entityDataType,
    required this.viewDataType,
    this.isNullable = false,
    this.isViewNullable = false,
  });

  final String name;
  final String entityDataType;
  final String viewDataType;

  final bool isNullable;
  final bool isViewNullable;

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      name: map['name'] as String,
      entityDataType: map['entityDataType'] as String,
      viewDataType: map['viewDataType'] as String,
    );
  }

  factory Property.fromJson(String source) =>
      Property.fromMap(json.decode(source) as Map<String, dynamic>);

  static void addProperty(
    List<Map<String, dynamic>> properties,
    Property property,
  ) {
    properties
      ..forEach((e) => e['isLastProperty'] = false)
      ..add({
        'name': property.name,
        'entityDataType': property.entityDataType,
        'viewDataType': property.viewDataType,
        'isNullable': property.isNullable,
        'isViewNullable': property.isViewNullable,
        'isLastProperty': true,
      });
  }
}
