import 'dart:convert';

class UpdateMethodProperties {
  const UpdateMethodProperties({
    required this.usecaseName,
    required this.paramsToUpdate,
  });

  final String usecaseName;

  final List<MethodParam> paramsToUpdate;

  factory UpdateMethodProperties.fromMap(Map<String, dynamic> map) {
    final paramsToUpdateRaw = map['paramsToUpdate'] as List;
    final paramsToUpdateL =
        paramsToUpdateRaw.map((e) => MethodParam.fromMap(e as Map<String, dynamic>)).toList();

    return UpdateMethodProperties(
      usecaseName: map['usecaseName'] as String,
      paramsToUpdate: paramsToUpdateL,
    );
  }

  factory UpdateMethodProperties.fromJson(String source) =>
      UpdateMethodProperties.fromMap(json.decode(source) as Map<String, dynamic>);

  static void addMethod(UpdateMethodProperties method, List<Map<String, dynamic>> methods) {
    final paramsToUpdateL = <Map<String, dynamic>>[];
    for (final param in method.paramsToUpdate) {
      MethodParam.addParam(param, paramsToUpdateL);
    }

    methods
      ..forEach((e) => e['isLastMethod'] = false)
      ..add({
        'usecaseName': method.usecaseName,
        'paramsToUpdate': paramsToUpdateL,
        'isLastMethod': true,
      });
  }
}

class MethodParam {
  const MethodParam({
    required this.paramName,
    required this.paramType,
  });

  final String paramName;
  final String paramType;

  factory MethodParam.fromMap(Map<String, dynamic> map) {
    return MethodParam(
      paramName: map['paramName'] as String,
      paramType: map['paramType'] as String,
    );
  }

  factory MethodParam.fromJson(String source) =>
      MethodParam.fromMap(json.decode(source) as Map<String, dynamic>);

  static void addParam(MethodParam param, List<Map<String, dynamic>> params) {
    params
      ..forEach((e) => e['isLastParam'] = false)
      ..add({
        'paramName': param.paramName,
        'paramType': param.paramType,
        'isLastParam': true,
      });
  }
}
