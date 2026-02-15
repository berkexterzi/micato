import 'package:flutter/material.dart';
import 'package:micato/models/product_model.dart';

class CartScreen extends StatelessWidget {
  final List<Data> cartProducts;
  final Set<int> cardIds;
  final Set<int> favoriteIds;
  final Map<int, int> productQuantities;
  final Function(int, int) onQuantityChanged;
  final Function(int) onRemoveProduct;

  const CartScreen({
    super.key,
    required this.cartProducts,
    required this.cardIds,
    required this.favoriteIds,
    required this.productQuantities,
    required this.onQuantityChanged,
    required this.onRemoveProduct,
  });

  void _increaseQuantity(int productId) {
    final currentQuantity = productQuantities[productId] ?? 1;
    onQuantityChanged(productId, currentQuantity + 1);
  }

  void _decreaseQuantity(int productId) {
    final currentQuantity = productQuantities[productId] ?? 1;
    if (currentQuantity > 1) {
      onQuantityChanged(productId, currentQuantity - 1);
    }
  }

  void _removeProduct(BuildContext context, int productId) {
    onRemoveProduct(productId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product removed from cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  double get _totalPrice {
    double total = 0;
    for (var product in cartProducts) {
      final price = product.priceValue;
      final quantity = productQuantities[product.id] ?? 1;
      total += price * quantity;
    }
    return total;
  }

  int get _totalItems {
    int total = 0;
    for (var product in cartProducts) {
      final quantity = productQuantities[product.id] ?? 1;
      total += quantity;
    }
    return total;
  }

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.shopping_cart, color: Colors.black87, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Shopping Cart',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              if (cartProducts.isNotEmpty)
                Text(
                  '$_totalItems items',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: cartProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add items to get started',
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartProducts.length,
                        itemBuilder: (context, index) {
                          return _buildCartItem(context, cartProducts[index]);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${_totalPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Checkout feature coming soon!',
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        'Checkout',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, size: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, Data product) {
    final quantity = productQuantities[product.id] ?? 1;
    final price = product.priceValue;
    final totalPrice = price * quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(20),
            ),
            child: Container(
              width: 120,
              height: 150,
              color: Colors.grey[100],
              child: Image.network(
                product.image ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey[300],
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        iconSize: 22,
                        onPressed: () => _removeProduct(context, product.id!),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: quantity > 1
                                  ? () => _decreaseQuantity(product.id!)
                                  : null,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(12),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.remove,
                                  size: 18,
                                  color: quantity > 1
                                      ? Colors.black87
                                      : Colors.grey[400],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => _increaseQuantity(product.id!),
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(12),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
