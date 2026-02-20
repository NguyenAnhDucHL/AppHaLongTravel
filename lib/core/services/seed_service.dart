import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SeedService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> seedData() async {
    try {
      // 1. Hotels
      await _seedCollection('hotels', [
        {
          'name': 'Paradise Suites Hotel',
          'description': 'Khách sạn 5 sao tọa lạc trên đảo Tuần Châu, nhìn ra vịnh Hạ Long.',
          'location': 'Tuần Châu, Hạ Long',
          'address': 'Đảo Tuần Châu, TP Hạ Long, Quảng Ninh',
          'lat': 20.9467,
          'lng': 106.9686,
          'rating': 4.8,
          'reviewCount': 245,
          'pricePerNight': 2500000,
          'currency': 'VND',
          'amenities': ['WiFi', 'Hồ bơi', 'Spa', 'Nhà hàng', 'Phòng gym', 'Bãi biển riêng'],
          'images': [
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
            'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800'
          ],
          'category': 'luxury',
          'featured': true,
        },
        {
            'name': 'Novotel Ha Long Bay',
            'description': 'Khách sạn quốc tế tiêu chuẩn 5 sao tại Bãi Cháy.',
            'location': 'Bãi Cháy, Hạ Long',
            'address': '160 Hạ Long, Bãi Cháy, TP Hạ Long',
            'lat': 20.9551, 'lng': 107.0495,
            'rating': 4.6, 'reviewCount': 189,
            'pricePerNight': 1800000, 'currency': 'VND',
            'amenities': ['WiFi', 'Hồ bơi', 'Nhà hàng', 'Bar', 'Phòng gym'],
            'images': ['https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800'], 
            'category': 'luxury', 'featured': true,
        },
        {
            'name': 'Wyndham Legend Halong',
            'description': 'Khu nghỉ dưỡng sang trọng bên bờ vịnh Hạ Long.',
            'location': 'Bãi Cháy, Hạ Long',
            'address': '12 Hạ Long, Bãi Cháy, TP Hạ Long',
            'lat': 20.9525, 'lng': 107.0532,
            'rating': 4.7, 'reviewCount': 320,
            'pricePerNight': 3200000, 'currency': 'VND',
            'amenities': ['WiFi', 'Hồ bơi vô cực', 'Spa', 'Nhà hàng', 'Casino'],
            'images': ['https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=800'], 
            'category': 'luxury', 'featured': true,
        }
      ]);

      // 2. Cruises
      await _seedCollection('cruises', [
        {
          'name': 'Ambassador Cruise',
          'description': 'Du thuyền 5 sao sang trọng nhất vịnh Hạ Long với 46 cabin.',
          'duration': '2 ngày 1 đêm',
          'route': 'Hạ Long Bay - Bái Tử Long',
          'lat': 20.9329,
          'lng': 106.9944,
          'rating': 4.9,
          'reviewCount': 380,
          'pricePerPerson': 4500000,
          'highlights': ['Hang Sửng Sốt', 'Đảo Ti Tốp', 'Chèo Kayak', 'Nấu ăn trên tàu'],
          'images': [
            'https://images.unsplash.com/photo-1599640845513-5c2b12c479e4?w=800',
            'https://images.unsplash.com/photo-1548574505-5e239809ee19?w=800'
          ],
          'included': ['Bữa ăn', 'Kayak', 'Hướng dẫn viên', 'Vé tham quan'],
          'excluded': ['Đồ uống', 'Tip', 'Spa'],
        },
        {
            'name': 'Paradise Elegance',
            'description': 'Du thuyền boutique cao cấp với phong cách Đông Dương.',
            'duration': '2 ngày 1 đêm', 'route': 'Hạ Long Bay',
            'lat': 20.9467, 'lng': 106.9686,
            'rating': 4.7, 'reviewCount': 256, 'pricePerPerson': 3800000,
            'highlights': ['Hang Luồn', 'Kayak', 'Tai Chi buổi sáng', 'BBQ trên boong'],
            'images': ['https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800'], 
            'included': ['Bữa ăn', 'Kayak', 'Vé hang'], 'excluded': ['Đồ uống', 'Tip'],
        },
        {
            'name': 'Stellar of the Seas',
            'description': 'Du thuyền hiện đại nhất vịnh Hạ Long với hồ bơi trên tàu.',
            'duration': '3 ngày 2 đêm', 'route': 'Hạ Long - Lan Hạ Bay',
            'lat': 20.8467, 'lng': 107.0911,
            'rating': 4.8, 'reviewCount': 198, 'pricePerPerson': 6500000,
            'highlights': ['Hồ bơi trên tàu', 'Đảo Cát Bà', 'Làng chài Việt Hải', 'Lặn biển'],
            'images': ['https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800'], 
            'included': ['Bữa ăn', 'Kayak', 'Xe đưa đón', 'Hồ bơi'],
            'excluded': ['Đồ uống cao cấp', 'Spa', 'Tip'],
        }
      ]);

      // 3. Tours
      await _seedCollection('tours', [
        {
          'name': 'Vịnh Hạ Long Full Day',
          'description': 'Tham quan toàn cảnh vịnh Hạ Long trong một ngày.',
          'duration': '8 tiếng',
          'difficulty': 'easy',
          'lat': 20.9551,
          'lng': 107.0495,
          'rating': 4.6,
          'reviewCount': 450,
          'pricePerPerson': 800000,
          'groupSize': 20,
          'images': [
             'https://images.unsplash.com/photo-1528127269322-539801943592?w=800'
          ],
        },
        {
            'name': 'Bái Tử Long Kayaking',
            'description': 'Chèo kayak khám phá vùng vịnh hoang sơ Bái Tử Long.',
            'duration': '6 tiếng', 'difficulty': 'moderate',
            'lat': 20.9167, 'lng': 107.2500,
            'rating': 4.8, 'reviewCount': 178, 'pricePerPerson': 1200000, 'groupSize': 10,
            'images': ['https://images.unsplash.com/photo-1540206395-688085723adb?w=800'],
        },
        {
            'name': 'Yên Tử Mountain Trek',
            'description': 'Leo núi Yên Tử - Đất Phật thiêng liêng.',
            'duration': '1 ngày', 'difficulty': 'hard',
            'lat': 21.1611, 'lng': 106.7214,
            'rating': 4.5, 'reviewCount': 312, 'pricePerPerson': 600000, 'groupSize': 15,
            'images': ['https://images.unsplash.com/photo-1552083378-f2b75303ca63?w=800'],
        }
      ]);
      
      // 4. Restaurants
      await _seedCollection('restaurants', [
        {
            'name': 'Nhà Hàng Phương Nam',
            'description': 'Nhà hàng hải sản nổi tiếng nhất Bãi Cháy.',
            'cuisine': ['Hải sản', 'Việt Nam'], 'address': 'Đường Hạ Long, Bãi Cháy',
            'lat': 20.9560, 'lng': 107.0480,
            'rating': 4.5, 'reviewCount': 520, 'priceRange': '\$\$',
            'popularDishes': ['Tôm hùm nướng', 'Sò điệp', 'Mực nướng sa tế'],
            'images': ['https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800'], 
            'openingHours': '10:00 - 22:00',
        },
        {
            'name': 'Quán Ăn Làng Chài',
            'description': 'Quán ăn bình dân view đẹp tại cảng cá Cái Dăm.',
            'cuisine': ['Hải sản', 'Bình dân'], 'address': 'Cảng cá Cái Dăm, Bãi Cháy',
            'lat': 20.9545, 'lng': 107.0525,
            'rating': 4.3, 'reviewCount': 350, 'priceRange': '\$',
            'popularDishes': ['Chả mực Hạ Long', 'Bún hải sản', 'Sam biển'],
            'images': ['https://images.unsplash.com/photo-1560611588-1fa3b6329eeb?w=800'], 
            'openingHours': '06:00 - 21:00',
        }
      ]);

      Get.snackbar('Success', 'Database seeded successfully!', 
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green.withOpacity(0.9), colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Seed failed: $e', 
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withOpacity(0.9), colorText: Colors.white);
      print('Seed error: $e');
    }
  }

  Future<void> _seedCollection(String collectionName, List<Map<String, dynamic>> items) async {
    final collection = _db.collection(collectionName);
    
    // Check if not empty
    final snapshot = await collection.limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print('Collection $collectionName is not empty, skipping...');
      return;
    }

    final batch = _db.batch();
    for (var item in items) {
      final docRef = collection.doc();
      batch.set(docRef, {
        ...item,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
    print('Seeded $collectionName with ${items.length} items');
  }
}
