import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'helpers.dart';

class Console {
  const Console({
    required this.title,
    required this.immersive,
    required this.target,
    required this.requiredSpace,
    required this.precautions,
    required this.equipments,
    required this.costs,
    required this.thumbnailPath,
  });

  final String title;
  final Map<String, String> immersive;
  final Map<String, String> target;
  final Map<String, String> requiredSpace;
  final Map<String, String> precautions;
  final Map<String, String> equipments;
  final Map<String, String> costs;
  final String thumbnailPath;

  @override
  bool operator ==(covariant Console other) {
    return runtimeType == other.runtimeType && other.title == title;
  }

  @override
  int get hashCode => title.hashCode;
}

Map<String, String> _toStrMap(Map<String, dynamic> map) {
  Map<String, String> out = {};
  for (final language in map.keys) {
    out[language] = map[language] as String;
  }
  return out;
}

Future<List<Console>> readConsoles() async {
  const jsonPath = '$rootAssetsPath/json/all_consoles.json';

  http.Response? input;
  try {
    input = await http.get(Uri.parse(jsonPath), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    });
  } on Exception {
    return [];
  }
  Map<String, dynamic> map = jsonDecode(input.body);
  List<Console> out = [];
  for (final console in map.keys) {
    out.add(Console(
      title: console,
      immersive: _toStrMap(map[console]['immersive']),
      target: _toStrMap(map[console]['target']),
      requiredSpace: _toStrMap(map[console]['requiredSpace']),
      precautions: _toStrMap(map[console]['precautions']),
      equipments: _toStrMap(map[console]['equipments']),
      costs: _toStrMap(map[console]['costs']),
      thumbnailPath:
          '$rootAssetsPath/images/consoles/${map[console]['thumbnailPath']}',
    ));
  }
  return out;
}
