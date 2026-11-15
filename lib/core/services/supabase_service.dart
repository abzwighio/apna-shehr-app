import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_config.dart';
import '../../models/city_area.dart';
import '../../models/shop.dart';
import '../../models/mosque.dart';
import '../../models/order.dart';
import '../../models/post.dart';
import 'demo_data_service.dart';

class SupabaseService {
  static final SupabaseService instance = SupabaseService._();
  SupabaseService._();

  bool _initialized = false;
  SupabaseClient? get client => _initialized ? Supabase.instance.client : null;

  Future<void> init() async {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.anonKey,
      );
      _initialized = true;
    } catch (e) {
      _initialized = false;
    }
  }

  // Fetch Cities
  Future<List<City>> getCities() async {
    if (!_initialized) return DemoDataService.cities;
    try {
      final res = await client!.from('cities').select().eq('is_active', true);
      final List data = res as List;
      if (data.isEmpty) return DemoDataService.cities;
      return data.map((c) => City.fromMap(c)).toList();
    } catch (e) {
      return DemoDataService.cities;
    }
  }

  // Fetch Areas
  Future<List<Area>> getAreas(String cityId) async {
    if (!_initialized) {
      return DemoDataService.areas.where((a) => a.cityId == cityId).toList();
    }
    try {
      final res = await client!.from('areas').select().eq('city_id', cityId);
      final List data = res as List;
      if (data.isEmpty) {
        return DemoDataService.areas.where((a) => a.cityId == cityId).toList();
      }
      return data.map((a) => Area.fromMap(a)).toList();
    } catch (e) {
      return DemoDataService.areas.where((a) => a.cityId == cityId).toList();
    }
  }

  // Fetch Shops with items
  Future<List<Shop>> getShops(String areaId, {String? categoryId}) async {
    if (!_initialized) {
      var list = DemoDataService.initialShops.where((s) => s.areaId == areaId).toList();
      if (categoryId != null && categoryId.isNotEmpty) {
        list = list.where((s) => s.categoryId == categoryId).toList();
      }
      return list;
    }
    try {
      var query = client!.from('shops').select('*, shop_items(*)').eq('area_id', areaId);
      if (categoryId != null && categoryId.isNotEmpty) {
        query = query.eq('category', categoryId);
      }
      final res = await query.order('featured_until', ascending: false);
      final List data = res as List;
      if (data.isEmpty) {
        var list = DemoDataService.initialShops.where((s) => s.areaId == areaId).toList();
        if (categoryId != null && categoryId.isNotEmpty) {
          list = list.where((s) => s.categoryId == categoryId).toList();
        }
        return list;
      }

      return data.map((s) {
        final rawItems = s['shop_items'] as List? ?? [];
        final items = rawItems.map((i) => ShopItem.fromMap(i, s['id'].toString())).toList();
        return Shop.fromMap(s, items);
      }).toList();
    } catch (e) {
      return DemoDataService.initialShops.where((s) => s.areaId == areaId).toList();
    }
  }

  // Fetch Mosques
  Future<List<Mosque>> getMosques(String areaId) async {
    if (!_initialized) {
      return DemoDataService.initialMosques.where((m) => m.areaId == areaId).toList();
    }
    try {
      final res = await client!.from('mosques').select().eq('area_id', areaId);
      final List data = res as List;
      if (data.isEmpty) {
        return DemoDataService.initialMosques.where((m) => m.areaId == areaId).toList();
      }
      return data.map((m) => Mosque.fromMap(m)).toList();
    } catch (e) {
      return DemoDataService.initialMosques.where((m) => m.areaId == areaId).toList();
    }
  }

  // Place Order
  Future<bool> placeOrder(AppOrder order) async {
    if (!_initialized) return true;
    try {
      await client!.from('orders').insert({
        'shop_id': order.shopId,
        'customer_name': order.customerName,
        'customer_phone': order.customerPhone,
        'delivery_address': order.deliveryAddress,
        'notes': order.notes,
        'total_pkr': order.totalPkr,
        'status': 'placed',
        'items': order.items.map((i) => i.toMap()).toList(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Fetch Posts
  Future<List<Post>> getPosts() async {
    if (!_initialized) return DemoDataService.initialPosts;
    try {
      final res = await client!.from('posts').select().order('created_at', ascending: false).limit(20);
      final List data = res as List;
      if (data.isEmpty) return DemoDataService.initialPosts;
      return data.map((p) => Post.fromMap(p)).toList();
    } catch (e) {
      return DemoDataService.initialPosts;
    }
  }
}
