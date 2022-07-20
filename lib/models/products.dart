import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackatron/models/users.dart';
import 'package:hackatron/widgets/extensions.dart';

final userRef =
    FirebaseFirestore.instance.collection('users').withConverter<Users>(
          fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()!),
          toFirestore: (users, _) => users.toJson(),
        );

class Products {
  Products({
    required this.name,
    required this.description,
    required this.price,
    required this.shareCount,
    required this.wishlistCount,
    required this.type,
    required this.userId,
    required this.images,
    required this.tags,
  });

  final String name;
  final String description;
  final double price;
  final int shareCount;
  late final int wishlistCount;
  final int type;
  final String userId;
  final List<dynamic> images;
  final List<dynamic> tags;

  Products.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          description: json['description']! as String,
          price: json['price']! as double,
          shareCount: json['shareCount'] as int,
          wishlistCount: json['wishlistCount'] as int,
          type: json['type'] as int,
          userId: json['userId'] as String,
          images: json['images'] as List<dynamic>,
          tags: json['tags'] as List<dynamic>,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price.toPrecision(2),
      'shareCount': shareCount,
      'wishlistCount': wishlistCount,
      'type': type,
      'userId': userId,
      'images': images,
      'tags': tags,
    };
  }
}
