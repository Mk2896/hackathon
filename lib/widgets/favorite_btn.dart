import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    Key? key,
    required this.isMyWishlistProduct,
    required this.updateWishlist,
  }) : super(key: key);

  final bool isMyWishlistProduct;
  final Future<void> Function() updateWishlist;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.updateWishlist();
      },
      icon: Icon(
        widget.isMyWishlistProduct ? Icons.favorite : Icons.favorite_border,
        color: const Color(primaryColor),
      ),
    );
  }
}
