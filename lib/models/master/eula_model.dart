class EulaModel {
  final String title;
  final String date;
  final String description;
  final List<String> contents;
  final List<EulaSection> data;

  EulaModel({
    required this.title,
    required this.date,
    required this.description,
    required this.contents,
    required this.data,
  });

  factory EulaModel.fromJson(Map<String, dynamic> json) {
    return EulaModel(
      title: json["title"] ?? "",
      date: json["date"] ?? "",
      description: json["description"] ?? "",
      contents: List<String>.from(json["contents"] ?? []),
      data: (json["data"] as List<dynamic>? ?? [])
          .map((item) => EulaSection.fromJson(item))
          .toList(),
    );
  }
}

class EulaSection {
  final String name;
  final String description;

  EulaSection({
    required this.name,
    required this.description,
  });

  factory EulaSection.fromJson(Map<String, dynamic> json) {
    return EulaSection(
      name: json["name"] ?? "",
      description: json["description"] ?? "",
    );
  }
}
