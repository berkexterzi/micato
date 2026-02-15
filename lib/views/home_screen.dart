import 'package:flutter/material.dart';
import 'package:micato/models/product_model.dart';
import 'package:micato/services/api_service.dart';
import 'package:micato/components/product_card.dart';
import 'package:micato/views/favorites_screen.dart';
import 'package:micato/views/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Data> _allProducts = [];
  List<Data> _filteredProducts = [];
  Set<int> cardIds = {};
  final Set<int> favoriteIds = {};
  Map<int, int> productQuantities = {};
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final productsModel = await _apiService.fetchProducts();
      setState(() {
        _allProducts = productsModel.data ?? [];
        _filteredProducts = _allProducts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ürünler yüklenemedi: $e')));
      }
    }
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where(
              (product) =>
                  product.name!.toLowerCase().contains(query.toLowerCase()) ||
                  product.description!.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  List<Data> get _favoriteProducts {
    return _allProducts
        .where((product) => favoriteIds.contains(product.id))
        .toList();
  }

  List<Data> get _cartProducts {
    return _allProducts
        .where((product) => cardIds.contains(product.id))
        .toList();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _updateQuantity(int productId, int quantity) {
    setState(() {
      if (quantity > 0) {
        productQuantities[productId] = quantity;
      } else {
        productQuantities.remove(productId);
      }
    });
  }

  void _removeFromCart(int productId) {
    setState(() {
      cardIds.remove(productId);
      productQuantities.remove(productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            _buildHomeTab(),
            FavoritesScreen(
              favoriteProducts: _favoriteProducts,
              cardIds: cardIds,
              favoriteIds: favoriteIds,
            ),
            CartScreen(
              cartProducts: _cartProducts,
              cardIds: cardIds,
              favoriteIds: favoriteIds,
              productQuantities: productQuantities,
              onQuantityChanged: _updateQuantity,
              onRemoveProduct: _removeFromCart,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 20,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: favoriteIds.isNotEmpty
                ? Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.favorite),
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              favoriteIds.length > 99
                                  ? '99+'
                                  : favoriteIds.length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: cardIds.isNotEmpty
                ? Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_cart),
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              cardIds.length > 99
                                  ? '99+'
                                  : cardIds.length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
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
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterProducts,
                    decoration: InputDecoration(
                      hintText: 'Search Products...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                _filterProducts('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return RotationTransition(
                        turns: Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: Icon(
                      _isGridView ? Icons.view_list : Icons.grid_view,
                      key: ValueKey(_isGridView),
                      color: Colors.black87,
                    ),
                  ),
                  onPressed: _toggleView,
                  tooltip: _isGridView ? 'List View' : 'Grid View',
                ),
              ),
            ],
          ),
        ),
        if (!_isLoading)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_filteredProducts.length} product${_filteredProducts.length != 1 ? 's' : ''} found',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'No products found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : _isGridView
              ? _buildGridView()
              : _buildListView(),
        ),
      ],
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      key: const ValueKey('grid'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: _filteredProducts[index],
          cardIds: cardIds,
          favoriteIds: favoriteIds,
          isListView: false,
          productQuantities: productQuantities,
          onQuantityChanged: _updateQuantity,
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      key: const ValueKey('list'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: _filteredProducts[index],
          cardIds: cardIds,
          favoriteIds: favoriteIds,
          isListView: true,
          productQuantities: productQuantities,
          onQuantityChanged: _updateQuantity,
        );
      },
    );
  }
}
