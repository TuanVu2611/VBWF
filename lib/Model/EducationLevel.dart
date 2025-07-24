class EducationLevel {
  int value;
  String label;

  EducationLevel({required this.value, required this.label});

  EducationLevel.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        label = json['label'];

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }
}
