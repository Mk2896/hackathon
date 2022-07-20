class Tags {
  Tags({required this.name});

  final String name;

  Tags.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
    };
  }
}
