import 'package:flutter/material.dart';
import '../models/city_area.dart';
import '../models/category.dart';
import '../models/shop.dart';
import '../models/mosque.dart';
import '../models/post.dart';
import '../core/services/supabase_service.dart';

class AppState extends ChangeNotifier {
  String _lang = 'ur'; // default to Urdu as per site's core audience
  bool _isLoading = true;

  List<City> _cities = [];
  List<Area> _areas = [];
  City? _selectedCity;
  Area? _selectedArea;

  List<Category> _categories = Category.initialCategories;
  List<Shop> _shops = [];
  List<Mosque> _mosques = [];
  List<Post> _posts = [];
  String _searchQuery = '';
  String? _selectedCategoryId;

  // Getters
  String get lang => _lang;
  bool get isLoading => _isLoading;
  List<City> get cities => _cities;
  List<Area> get areas => _areas;
  City? get selectedCity => _selectedCity;
  Area? get selectedArea => _selectedArea;
  List<Category> get categories => _categories;
  List<Shop> get shops => _shops;
  List<Mosque> get mosques => _mosques;
  List<Post> get posts => _posts;
  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;

  // Saste Products (Cheapest priced items from active shops)
  List<Map<String, dynamic>> get cheapestItems {
    final list = <Map<String, dynamic>>[];
    for (var shop in _shops) {
      for (var item in shop.items) {
        if (item.price > 0 && item.isAvailable) {
          list.add({
            'shop': shop,
            'item': item,
          });
        }
      }
    }
    list.sort((a, b) => (a['item'] as ShopItem).effectivePrice.compareTo((b['item'] as ShopItem).effectivePrice));
    return list.take(10).toList();
  }

  // Filtered Shops
  List<Shop> get filteredShops {
    return _shops.where((s) {
      final matchesCat = _selectedCategoryId == null || s.categoryId == _selectedCategoryId;
      final matchesQuery = _searchQuery.isEmpty ||
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.items.any((i) => i.name.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCat && matchesQuery;
    }).toList();
  }

  void toggleLanguage() {
    _lang = _lang == 'ur' ? 'en' : 'ur';
    notifyListeners();
  }

  void setLanguage(String code) {
    _lang = code;
    notifyListeners();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await SupabaseService.instance.init();
    _cities = await SupabaseService.instance.getCities();
    if (_cities.isNotEmpty) {
      _selectedCity = _cities.firstWhere(
        (c) => c.id == 'hyderabad',
        orElse: () => _cities.first,
      );
      _areas = await SupabaseService.instance.getAreas(_selectedCity!.id);
      if (_areas.isNotEmpty) {
        _selectedArea = _areas.firstWhere(
          (a) => a.id == 'latifabad',
          orElse: () => _areas.first,
        );
      }
    }

    await loadDataForCurrentArea();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectCity(City city) async {
    _selectedCity = city;
    _areas = await SupabaseService.instance.getAreas(city.id);
    _selectedArea = _areas.isNotEmpty ? _areas.first : null;
    await loadDataForCurrentArea();
    notifyListeners();
  }

  Future<void> selectArea(Area area) async {
    _selectedArea = area;
    await loadDataForCurrentArea();
    notifyListeners();
  }

  void selectCategory(String? categoryId) {
    if (_selectedCategoryId == categoryId) {
      _selectedCategoryId = null; // Toggle off
    } else {
      _selectedCategoryId = categoryId;
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadDataForCurrentArea() async {
    if (_selectedArea == null) return;
    _shops = await SupabaseService.instance.getShops(_selectedArea!.id);
    _mosques = await SupabaseService.instance.getMosques(_selectedArea!.id);
    _posts = await SupabaseService.instance.getPosts();
    notifyListeners();
  }
}
