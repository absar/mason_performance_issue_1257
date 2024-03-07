import 'package:mason/mason.dart';

import 'property.dart';
import 'update_method_properties.dart';

Future<void> run(HookContext context) async {
  final hasProperties =
      context.vars['properties'] != null && (context.vars['properties'] as List).isNotEmpty;

  final hasUpdateMethods =
      context.vars['updateMethods'] != null && (context.vars['updateMethods'] as List).isNotEmpty;

  final properties = <Map<String, dynamic>>[];

  if (hasProperties) {
    final seededProperties = context.vars['properties'] as List;
    for (final property in seededProperties) {
      Property.addProperty(
        properties,
        Property.fromMap(property as Map<String, dynamic>),
      );
    }
  }

  final updateMethods = <Map<String, dynamic>>[];

  if (hasUpdateMethods) {
    final seededUpdateMethods = context.vars['updateMethods'] as List;
    for (final method in seededUpdateMethods) {
      UpdateMethodProperties.addMethod(
        UpdateMethodProperties.fromMap(method as Map<String, dynamic>),
        updateMethods,
      );
    }
  }

  context.vars.removeWhere((key, value) => ['properties', 'updateMethods'].contains(key));
  context.vars = {
    ...context.vars,
    'properties': properties,
    'first2Properties': firstNProperties(properties, 2),
    'first2PropertiesReversed': firstNProperties(properties, 2, reversed: true),
    'first3Properties': firstNProperties(properties, 3),
    'first3PropertiesReversed': firstNProperties(properties, 3, reversed: true),
    'first4Properties': firstNProperties(properties, 4),
    'notNullProperties': notNullProperties(properties),
    'notNullViewProperties': notNullViewProperties(properties),
    'hasProperties': properties.isNotEmpty,
    'updateMethods': updateMethods,
    'hasUpdateMethods': updateMethods.isNotEmpty,
  };
}

List<Map<String, dynamic>> firstNProperties(
  List<Map<String, dynamic>> properties,
  int n, {
  bool reversed = false,
}) {
  var result = properties.take(n).map((e) => Map<String, dynamic>.from(e)).toList();
  return (reversed ? result.reversed.toList() : result)..last['isLastProperty'] = true;
}

List<Map<String, dynamic>> notNullProperties(
  List<Map<String, dynamic>> properties, {
  bool reversed = false,
}) {
  final result = properties
      .where((it) => !(it['isNullable'] as bool))
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
  return (reversed ? result.reversed.toList() : result)..last['isLastProperty'] = true;
}

List<Map<String, dynamic>> notNullViewProperties(
  List<Map<String, dynamic>> properties, {
  bool reversed = false,
}) {
  final result = properties
      .where((it) => !(it['isViewNullable'] as bool))
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
  return (reversed ? result.reversed.toList() : result)..last['isLastProperty'] = true;
}

Future<void> preGenHookWrapper(HookContext context,
    {Function(Map<String, dynamic> value)? preGenHookChanged}) async {
  await run(context);
  preGenHookChanged?.call(context.vars);
}
