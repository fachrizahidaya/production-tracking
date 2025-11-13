import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:textile_tracking/models/master/eula_model.dart';

class EulaService {
  static Future<EulaModel> loadEula() async {
    final jsonString = await rootBundle.loadString('assets/eula.json');
    final jsonMap = json.decode(jsonString);
    return EulaModel.fromJson(jsonMap);
  }
}
