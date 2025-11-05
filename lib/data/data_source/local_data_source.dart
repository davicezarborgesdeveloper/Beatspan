import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';

abstract class LocalDataSource {
  Future<dynamic> getDataFromJson(String fileName);
}

class LocalDataSourceImpl implements LocalDataSource {
  @override
  Future<dynamic> getDataFromJson(String fileName) async {
    try {
      final String response = await rootBundle.loadString(fileName);
      return await json.decode(response);
    } on Exception catch (e, s) {
      log('erro ao trazer json local', error: e, stackTrace: s);
    }
    return '';
  }
}
