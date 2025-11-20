import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:textile_tracking/models/auth/terms_conditions_model.dart';

class TermsConditionsService {
  static Future<TermsConditionsModel> loadTermsConditions() async {
    final jsonString =
        await rootBundle.loadString('assets/terms_conditions.json');
    final jsonMap = json.decode(jsonString);
    return TermsConditionsModel.fromJson(jsonMap);
  }
}
