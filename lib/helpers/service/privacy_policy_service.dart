import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:textile_tracking/models/auth/privacy_policy_model.dart';

class PrivacyPolicyService {
  static Future<PrivacyPolicyModel> loadPrivacyPolicy() async {
    final jsonString =
        await rootBundle.loadString('assets/privacy_policy.json');
    final jsonMap = json.decode(jsonString);
    return PrivacyPolicyModel.fromJson(jsonMap);
  }
}
