class PrivacyPolicyModel {
  final String title;
  final String date;
  final String description;
  final List<String> contents;
  final List<PrivacyPolicySection> data;

  PrivacyPolicyModel({
    required this.title,
    required this.date,
    required this.description,
    required this.contents,
    required this.data,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      title: json["title"] ?? "",
      date: json["date"] ?? "",
      description: json["description"] ?? "",
      contents: List<String>.from(json["contents"] ?? []),
      data: (json["data"] as List<dynamic>? ?? [])
          .map((item) => PrivacyPolicySection.fromJson(item))
          .toList(),
    );
  }
}

class PrivacyPolicySection {
  final String name;
  final String description;

  PrivacyPolicySection({
    required this.name,
    required this.description,
  });

  factory PrivacyPolicySection.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicySection(
      name: json["name"] ?? "",
      description: json["description"] ?? "",
    );
  }
}
