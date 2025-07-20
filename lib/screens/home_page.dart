import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/helpers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Product> _products = [
    Product(id: 'm1', title: 'Men Jacket', price: 59, gender: Gender.men, imageAsset: 'assets/menjacket.jpg', imagePath: '', name: ''),
    Product(id: 'm2', title: 'Men Sneakers', price: 85, gender: Gender.men, imageAsset: 'assets/men_shoes.jpg', imagePath: '', name: ''),
    Product(id: 'f1', title: 'Women Dress', price: 72, gender: Gender.women, imageAsset: 'assets/womendress.jpg', imagePath: '', name: ''),
    Product(id: 'f2', title: 'Women Blouse', price: 46, gender: Gender.women, imageAsset: 'assets/womenblouses.jpg', imagePath: '', name: ''),
    Product(id: 'un1', title: 'Unisex Cap', price: 19, gender: Gender.unisex, imageAsset: 'assets/unisexcap.jpg', imagePath: '', name: ''),
    Product(id: 'un2', title: 'Unisex Hoodie', price: 49, gender: Gender.unisex, imageAsset: 'assets/unisexhoodie.jpg', imagePath: '', name: ''),
    Product(id: 'm3', title: 'Men Pants 1', price: 45, gender: Gender.men, imageAsset: 'assets/mpants1.jpg', imagePath: '', name: ''),
    Product(id: 'm4', title: 'Men Pants 2', price: 48, gender: Gender.men, imageAsset: 'assets/mpants2.jpg', imagePath: '', name: ''),
    Product(id: 'm5', title: 'Men Shirt', price: 39, gender: Gender.men, imageAsset: 'assets/mshirt2.jpg', imagePath: '', name: ''),
    Product(id: 'm6', title: 'Men Shorts', price: 29, gender: Gender.men, imageAsset: 'assets/mshort1.jpg', imagePath: '', name: ''),
    Product(id: 'un3', title: 'Unisex Cap', price: 22, gender: Gender.unisex, imageAsset: 'assets/uncap1.jpg', imagePath: '', name: ''),
    Product(id: 'un4', title: 'Unisex Jacket', price: 65, gender: Gender.unisex, imageAsset: 'assets/unjacket1.jpg', imagePath: '', name: ''),
    Product(id: 'un5', title: 'Unisex Shoes', price: 80, gender: Gender.unisex, imageAsset: 'assets/unshoes1.jpg', imagePath: '', name: ''),
    Product(id: 'un6', title: 'Unisex T-shirt', price: 30, gender: Gender.unisex, imageAsset: 'assets/untshirt1.jpg', imagePath: '', name: ''),
    Product(id: 'f3', title: 'Crop Top 1', price: 35, gender: Gender.women, imageAsset: 'assets/wmcroptop1.jpg', imagePath: '', name: ''),
    Product(id: 'f4', title: 'Crop Top 2', price: 38, gender: Gender.women, imageAsset: 'assets/wmcroptop2.jpg', imagePath: '', name: ''),
    Product(id: 'f5', title: 'Denim Pants', price: 55, gender: Gender.women, imageAsset: 'assets/wmdenim1.jpg', imagePath: '', name: ''),
    Product(id: 'f6', title: 'Dress Style 2', price: 75, gender: Gender.women, imageAsset: 'assets/wmdress1.jpg', imagePath: '', name: ''),
  ];

  String _type = 'all';
  String _search = '';

  late double _minPrice;
  late double _maxPrice;
  late RangeValues _priceRange;

  final List<String> _sliderImages = [
    'assets/dresscream.jpg',
    'assets/dresspink.jpg',
    'assets/shoe.jpg',
    'assets/slipper.jpg',
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _minPrice = _products.map((p) => p.price).reduce((a, b) => a < b ? a : b).toDouble();
    _maxPrice = _products.map((p) => p.price).reduce((a, b) => a > b ? a : b).toDouble();
    _priceRange = RangeValues(_minPrice, _maxPrice);
  }

  List<Product> get _filtered {
    var out = _type == 'all'
        ? _products
        : _products.where((p) {
            return (_type == 'men' && p.gender == Gender.men) ||
                (_type == 'women' && p.gender == Gender.women) ||
                (_type == 'unisex' && p.gender == Gender.unisex);
          }).toList();

    if (_search.isNotEmpty) {
      out = out.where((p) => p.title.toLowerCase().contains(_search.toLowerCase())).toList();
    }

    out = out.where((p) => p.price >= _priceRange.start && p.price <= _priceRange.end).toList();
    out.sort((a, b) => a.price.compareTo(b.price));
    return out;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Palette.brown,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(radius: 16, backgroundImage: AssetImage('assets/logo.jpg')),
            const SizedBox(width: 10),
            const Text('Home', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 36,
                child: TextField(
                  onChanged: (val) => setState(() => _search = val),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    hintText: 'Search...',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No new notifications")),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: bottomNav(0, context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildSlider()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildFilters()),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final p = _filtered[i];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/product', arguments: p),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 3,
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.asset(
                                p.imageAsset,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Text(
                                  p.title,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                Text('₱${p.price.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _filtered.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3 / 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _sliderImages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  _sliderImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_sliderImages.length, (index) {
                bool isActive = index == _currentPage;
                return GestureDetector(
                  onTap: () => _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: isActive ? 14 : 10,
                    height: isActive ? 14 : 10,
                    decoration: BoxDecoration(
                      color: isActive ? Palette.brown : Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _dropdown(_type, ['all', 'men', 'women', 'unisex'], (v) => setState(() => _type = v!)),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: Row(
            children: [
              const Text('Price:', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 6),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                  ),
                  child: RangeSlider(
                    values: _priceRange,
                    min: _minPrice,
                    max: _maxPrice,
                    divisions: (_maxPrice - _minPrice).round(),
                    activeColor: Palette.brown,
                    labels: RangeLabels(
                      '₱${_priceRange.start.toStringAsFixed(0)}',
                      '₱${_priceRange.end.toStringAsFixed(0)}',
                    ),
                    onChanged: (values) => setState(() => _priceRange = values),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        isExpanded: true,
      ),
    );
  }
}

class Palette {
  static const Color brown = Color(0xFF8B4513);
}
