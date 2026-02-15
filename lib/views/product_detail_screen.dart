import 'package:flutter/material.dart';
import 'package:micato/models/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final Data product;
  final Set<int> cardIds;
  final Set<int> favoriteIds;
  final Map<int, int> productQuantities;
  final Function(int, int) onQuantityChanged;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.cardIds,
    required this.favoriteIds,
    required this.productQuantities,
    required this.onQuantityChanged,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isAddedtoFavorites() {
    return widget.favoriteIds.contains(widget.product.id);
  }

  bool isInCart() {
    return widget.cardIds.contains(widget.product.id);
  }

  int getQuantity() {
    return widget.productQuantities[widget.product.id] ?? 1;
  }

  void _increaseQuantity() {
    final currentQuantity = getQuantity();
    widget.onQuantityChanged(widget.product.id!, currentQuantity + 1);
    setState(() {});
  }

  void _decreaseQuantity() {
    final currentQuantity = getQuantity();
    if (currentQuantity > 1) {
      widget.onQuantityChanged(widget.product.id!, currentQuantity - 1);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_${widget.product.id}',
                child: Container(
                  color: Colors.grey[100],
                  child: Image.network(
                    widget.product.image ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.price ?? '0',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (isAddedtoFavorites()) {
                                widget.favoriteIds.remove(widget.product.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${widget.product.name} removed from Favorites!',
                                    ),
                                    backgroundColor: Colors.grey[700],
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } else {
                                widget.favoriteIds.add(widget.product.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${widget.product.name} added to Favorites!',
                                    ),
                                    backgroundColor: Colors.pinkAccent,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            });
                          },
                          icon: Icon(
                            isAddedtoFavorites()
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.product.name ?? '',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.product.tagline != null &&
                        widget.product.tagline!.isNotEmpty)
                      Text(
                        widget.product.tagline!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const SizedBox(height: 24),
                    Container(height: 1, color: Colors.grey[200]),
                    const SizedBox(height: 24),
                    if (widget.product.specs != null &&
                        widget.product.specs!.isNotEmpty) ...[
                      const Text(
                        'Specifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...widget.product.specs!.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getIconForSpec(entry.key),
                                  size: 20,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getSpecTitle(entry.key),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      entry.value,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 24),
                    ],
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.product.description ?? '',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
          child: isInCart()
              ? Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: getQuantity() > 1 ? _decreaseQuantity : null,
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(16),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 24,
                                color: getQuantity() > 1
                                    ? Colors.black87
                                    : Colors.grey[400],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              getQuantity().toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _increaseQuantity,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(16),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 24,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'In Cart',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.cardIds.add(widget.product.id!);
                      widget.onQuantityChanged(widget.product.id!, 1);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.product.name} added to cart!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
        ),
      ),
    );
  }

  IconData _getIconForSpec(String key) {
    switch (key.toLowerCase()) {
      case 'chip':
      case 'processor':
      case 'cpu':
        return Icons.memory;
      case 'camera':
        return Icons.camera_alt;
      case 'display':
      case 'screen':
        return Icons.phone_iphone;
      case 'material':
        return Icons.settings;
      case 'battery':
        return Icons.battery_charging_full;
      case 'id':
      case 'security':
        return Icons.fingerprint;
      case 'ram':
      case 'memory':
        return Icons.developer_board;
      case 'storage':
        return Icons.storage;
      case 'type':
        return Icons.category;
      case 'connection':
        return Icons.bluetooth;
      case 'anc':
        return Icons.headset;
      case 'gpu':
        return Icons.videogame_asset;
      case 'weight':
        return Icons.fitness_center;
      case 'flight time':
      case 'battery life':
        return Icons.access_time;
      case 'range':
        return Icons.signal_cellular_alt;
      case 'sensor':
        return Icons.camera;
      case 'video':
        return Icons.videocam;
      case 'iso':
        return Icons.iso;
      case 'af points':
        return Icons.center_focus_strong;
      case 'acceleration':
        return Icons.speed;
      case 'top speed':
        return Icons.local_fire_department;
      case 'drive':
        return Icons.drive_eta;
      case 'refresh':
        return Icons.refresh;
      case 'hdmi':
        return Icons.settings_input_hdmi;
      case 'power':
        return Icons.power;
      case 'filter':
        return Icons.filter_alt;
      case 'technology':
        return Icons.architecture;
      case 'water resistance':
      case 'waterproof':
        return Icons.water_drop;
      case 'stabilization':
        return Icons.videocam;
      case 'photo':
        return Icons.photo_camera;
      case 'modes':
        return Icons.view_carousel;
      case 'charging':
      case 'charging time':
        return Icons.charging_station;
      case 'dpi':
        return Icons.mouse;
      case 'buttons':
        return Icons.touch_app;
      case 'capacity':
        return Icons.battery_full;
      case 'output':
        return Icons.power;
      case 'ports':
        return Icons.usb;
      case 'suction':
        return Icons.cleaning_services;
      case 'mop':
        return Icons.wash;
      case 'mapping':
        return Icons.map;
      default:
        return Icons.info_outline;
    }
  }

  String _getSpecTitle(String key) {
    switch (key.toLowerCase()) {
      case 'chip':
      case 'processor':
        return 'Processor';
      case 'cpu':
        return 'CPU';
      case 'camera':
        return 'Camera';
      case 'display':
      case 'screen':
        return 'Display';
      case 'material':
        return 'Material';
      case 'battery':
        return 'Battery';
      case 'id':
      case 'security':
        return 'Security';
      case 'ram':
      case 'memory':
        return 'RAM';
      case 'storage':
        return 'Storage';
      case 'type':
        return 'Type';
      case 'connection':
        return 'Connection';
      case 'anc':
        return 'Noise Cancelling';
      case 'gpu':
        return 'GPU';
      case 'weight':
        return 'Weight';
      case 'flight time':
        return 'Flight Time';
      case 'battery life':
        return 'Battery Life';
      case 'range':
        return 'Range';
      case 'sensor':
        return 'Sensor';
      case 'video':
        return 'Video';
      case 'iso':
        return 'ISO Range';
      case 'af points':
        return 'AF Points';
      case 'acceleration':
        return 'Acceleration';
      case 'top speed':
        return 'Top Speed';
      case 'drive':
        return 'Drive Type';
      case 'refresh':
        return 'Refresh Rate';
      case 'hdmi':
        return 'HDMI';
      case 'power':
        return 'Power';
      case 'filter':
        return 'Filter';
      case 'technology':
        return 'Technology';
      case 'water resistance':
        return 'Water Resistance';
      case 'waterproof':
        return 'Waterproof';
      case 'stabilization':
        return 'Stabilization';
      case 'photo':
        return 'Photo';
      case 'modes':
        return 'Modes';
      case 'charging':
      case 'charging time':
        return 'Charging Time';
      case 'dpi':
        return 'DPI';
      case 'buttons':
        return 'Buttons';
      case 'capacity':
        return 'Capacity';
      case 'output':
        return 'Output';
      case 'ports':
        return 'Ports';
      case 'suction':
        return 'Suction Power';
      case 'mop':
        return 'Mopping';
      case 'mapping':
        return 'Mapping';
      default:
        return key;
    }
  }
}
