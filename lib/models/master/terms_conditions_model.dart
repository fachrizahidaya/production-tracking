class TermsConditionsModel {
  final String title;
  final String date;
  final String description;
  final List<String> contents;
  final List<TermsConditionsSection> data;

  TermsConditionsModel({
    required this.title,
    required this.date,
    required this.description,
    required this.contents,
    required this.data,
  });

  factory TermsConditionsModel.fromJson(Map<String, dynamic> json) {
    return TermsConditionsModel(
      title: json["title"] ?? "",
      date: json["date"] ?? "",
      description: json["description"] ?? "",
      contents: List<String>.from(json["contents"] ?? []),
      data: (json["data"] as List<dynamic>? ?? [])
          .map((item) => TermsConditionsSection.fromJson(item))
          .toList(),
    );
  }
}

class TermsConditionsSection {
  final String name;
  final String description;

  TermsConditionsSection({
    required this.name,
    required this.description,
  });

  factory TermsConditionsSection.fromJson(Map<String, dynamic> json) {
    return TermsConditionsSection(
      name: json["name"] ?? "",
      description: json["description"] ?? "",
    );
  }
}
