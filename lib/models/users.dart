class Users {
  const Users({
    required this.name,
    required this.email,
    this.profession,
    required this.photoURL,
    this.wishlist,
  });

  Users.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          email: json['email']! as String,
          photoURL: json['photoURL']! as String,
          profession: json['profession'] as String?,
          wishlist: json['wishlist'] as List<dynamic>,
        );

  final String name;
  final String email;
  final String photoURL;
  final String? profession;
  final List<dynamic>? wishlist;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'profession': profession,
      "wishlist": wishlist,
    };
  }
}
