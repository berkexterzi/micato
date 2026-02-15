import 'package:flutter/material.dart';
import 'package:micato/models/product_model.dart';
import 'package:micato/components/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Data> favoriteProducts;
  final Set<int> cardIds;
  final Set<int> favoriteIds;

  const FavoritesScreen({
    super.key,
    required this.favoriteProducts,
    required this.cardIds,
    required this.favoriteIds,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            children: [
              Icon(Icons.favorite, color: Colors.red, size: 28),
              SizedBox(width: 12),
              Text(
                'Favorites',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: favoriteProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add items to your favorites',
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoriteProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: favoriteProducts[index],
                      cardIds: cardIds,
                      favoriteIds: favoriteIds,
                      isListView: true,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
