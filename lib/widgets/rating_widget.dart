import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating; // 0 - 5

  const RatingStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor();
    final hasHalf = (rating - fullStars) >= 0.5;

    return Row(
      children: List.generate(5, (i) {
        if (i < fullStars) {
          return const Icon(Icons.star, size: 16, color: Colors.amber);
        }
        if (i == fullStars && hasHalf) {
          return const Icon(Icons.star_half, size: 16, color: Colors.amber);
        }
        return const Icon(Icons.star_border, size: 16, color: Colors.amber);
      }),
    );
  }
}