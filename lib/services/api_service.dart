import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart';
import 'package:micato/models/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://wantapi.com/products.php';

  Future<ProductsModel> fetchProducts() async {
    try {
      final response = await get(
        Uri.parse(baseUrl),
      ).timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ProductsModel.fromJson(data);
      } else {
        throw Exception('Api erişim hatası :(');
      }
    } on TimeoutException {
      // 2 saniye içinde yanıt gelmezse statik veriyi döndür
      return _getStaticProducts();
    } catch (e) {
      // Herhangi bir hata durumunda da statik veriyi döndür
      return _getStaticProducts();
    }
  }

  ProductsModel _getStaticProducts() {
    final staticData = {
      "status": "success",
      "meta": {
        "title": "Static Products",
        "description": "Offline product list",
        "copyright": "© 2024",
        "generated": DateTime.now().toIso8601String(),
        "count": 20,
      },
      "data": [
        {
          "id": 1,
          "name": "iPhone 15 Pro",
          "tagline": "Titanium. So strong. So light. So Pro.",
          "description":
              "Premium smartphone powered by A17 Pro chip with titanium design",
          "price": "999",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=400&h=400&fit=crop",
          "specs": {
            "Display": "6.1-inch Super Retina XDR",
            "Chip": "A17 Pro",
            "RAM": "8GB",
            "Storage": "256GB",
          },
        },
        {
          "id": 2,
          "name": "Samsung Galaxy S24 Ultra",
          "tagline": "Galaxy AI is here",
          "description":
              "Most advanced Galaxy experience with AI-powered camera and S Pen",
          "price": "1199",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=400&h=400&fit=crop",
          "specs": {
            "Display": "6.8-inch Dynamic AMOLED 2X",
            "Chip": "Snapdragon 8 Gen 3",
            "RAM": "12GB",
            "Storage": "512GB",
          },
        },
        {
          "id": 3,
          "name": "MacBook Air M3",
          "tagline": "Lean. Mean. M3 machine.",
          "description":
              "Incredible performance and all-day battery with M3 chip",
          "price": "1299",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=400&fit=crop",
          "specs": {
            "Display": "13.6-inch Liquid Retina",
            "Chip": "Apple M3",
            "RAM": "16GB",
            "Storage": "512GB SSD",
          },
        },
        {
          "id": 4,
          "name": "Sony WH-1000XM5",
          "tagline": "Industry-leading noise cancellation",
          "description":
              "Premium headphones with best noise canceling technology",
          "price": "399",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=400&h=400&fit=crop",
          "specs": {
            "Type": "Over-Ear",
            "Connection": "Bluetooth 5.2",
            "Battery": "30 hours",
            "ANC": "HD Noise Cancelling",
          },
        },
        {
          "id": 5,
          "name": "iPad Pro 12.9",
          "tagline": "Supercharged by M2",
          "description":
              "Professional tablet experience with M2 chip and ProMotion display",
          "price": "1099",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400&h=400&fit=crop",
          "specs": {
            "Display": "12.9-inch Liquid Retina XDR",
            "Chip": "Apple M2",
            "RAM": "16GB",
            "Storage": "512GB",
          },
        },
        {
          "id": 6,
          "name": "Apple Watch Ultra 2",
          "tagline": "Next-level adventure",
          "description":
              "Smartwatch designed for extreme sports and adventures",
          "price": "799",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=400&h=400&fit=crop",
          "specs": {
            "Display": "1.92-inch Retina",
            "Chip": "S9 SiP",
            "Battery": "36 hours",
            "Water Resistance": "100m",
          },
        },
        {
          "id": 7,
          "name": "AirPods Pro 2",
          "tagline": "Adaptive Audio. Now playing.",
          "description": "USB-C charging case with advanced noise cancellation",
          "price": "249",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1606841837239-c5a1a4a07af7?w=400&h=400&fit=crop",
          "specs": {
            "Type": "In-Ear",
            "Connection": "Bluetooth 5.3",
            "Battery": "6 hours",
            "Charging": "USB-C",
          },
        },
        {
          "id": 8,
          "name": "PlayStation 5",
          "tagline": "Play Has No Limits",
          "description":
              "Next-gen gaming experience with ultra-fast SSD and ray tracing",
          "price": "499",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=400&h=400&fit=crop",
          "specs": {
            "CPU": "AMD Zen 2",
            "GPU": "10.28 TFLOPS RDNA 2",
            "RAM": "16GB GDDR6",
            "Storage": "825GB SSD",
          },
        },
        {
          "id": 9,
          "name": "DJI Mini 4 Pro",
          "tagline": "Mini camera. Mega upgrade.",
          "description": "Professional drone technology in compact size",
          "price": "759",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1473968512647-3e447244af8f?w=400&h=400&fit=crop",
          "specs": {
            "Camera": "4K/60fps HDR",
            "Weight": "249g",
            "Flight Time": "34 minutes",
            "Range": "10km",
          },
        },
        {
          "id": 10,
          "name": "Canon EOS R6 Mark II",
          "tagline": "Capture the moment",
          "description":
              "Professional photography with 24.2MP sensor and advanced AF system",
          "price": "2499",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=400&h=400&fit=crop",
          "specs": {
            "Sensor": "24.2MP Full Frame",
            "Video": "4K 60p",
            "ISO": "100-102400",
            "AF Points": "1053",
          },
        },
        {
          "id": 11,
          "name": "Tesla Model 3",
          "tagline": "Electric for everyone",
          "description": "Long-range, high-performance electric vehicle",
          "price": "40240",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=400&h=400&fit=crop",
          "specs": {
            "Range": "374 miles",
            "Acceleration": "0-60 mph 3.1s",
            "Top Speed": "162 mph",
            "Drive": "AWD",
          },
        },
        {
          "id": 12,
          "name": "LG OLED C3",
          "tagline": "Picture perfect",
          "description": "Perfect picture quality with α9 Gen6 AI processor",
          "price": "1299",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400&h=400&fit=crop",
          "specs": {
            "Display": "55-inch 4K OLED",
            "Processor": "α9 Gen6 AI",
            "Refresh": "120Hz",
            "HDMI": "HDMI 2.1",
          },
        },
        {
          "id": 13,
          "name": "Dyson V15 Detect",
          "tagline": "Reveals invisible dust",
          "description":
              "Vacuum cleaner that detects even invisible dust with laser technology",
          "price": "649",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1558317374-067fb5f30001?w=400&h=400&fit=crop",
          "specs": {
            "Power": "230 AW",
            "Battery": "60 minutes",
            "Filter": "HEPA",
            "Technology": "Laser Detect",
          },
        },
        {
          "id": 14,
          "name": "Bose Earbuds II",
          "tagline": "Personalized noise cancellation",
          "description":
              "Wireless earbuds with personalized noise cancellation",
          "price": "299",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1609043457779-5026bece8290?w=400&h=400&fit=crop",
          "specs": {
            "Type": "True Wireless",
            "ANC": "CustomTune",
            "Battery": "6 hours",
            "Water Resistance": "IPX4",
          },
        },
        {
          "id": 15,
          "name": "GoPro HERO 12 Black",
          "tagline": "Unbelievable image quality",
          "description":
              "Action camera with HDR video and advanced stabilization",
          "price": "399",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1519638399535-1b036603ac77?w=400&h=400&fit=crop",
          "specs": {
            "Video": "5.3K60 HDR",
            "Stabilization": "HyperSmooth 6.0",
            "Photo": "27MP",
            "Waterproof": "33ft",
          },
        },
        {
          "id": 16,
          "name": "Nintendo Switch OLED",
          "tagline": "Get together. Play together.",
          "description": "Hybrid gaming console with enhanced OLED screen",
          "price": "349",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1578303512597-81e6cc155b3e?w=400&h=400&fit=crop",
          "specs": {
            "Display": "7-inch OLED",
            "Storage": "64GB",
            "Battery": "4.5-9 hours",
            "Modes": "TV/Handheld/Tabletop",
          },
        },
        {
          "id": 17,
          "name": "Kindle Paperwhite",
          "tagline": "The best Kindle ever",
          "description":
              "E-book reader with waterproof design and long battery life",
          "price": "139",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1592496431122-2349e0fbc666?w=400&h=400&fit=crop",
          "specs": {
            "Display": "6.8-inch E Ink",
            "Storage": "16GB",
            "Battery": "10 weeks",
            "Waterproof": "IPX8",
          },
        },
        {
          "id": 18,
          "name": "Logitech MX Master 3S",
          "tagline": "Master your flow",
          "description":
              "Professional mouse with quiet clicks and MagSpeed wheel",
          "price": "99",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400&h=400&fit=crop",
          "specs": {
            "DPI": "8000",
            "Connection": "Bluetooth/USB",
            "Battery": "70 days",
            "Buttons": "7 programmable",
          },
        },
        {
          "id": 19,
          "name": "Anker PowerCore 20K",
          "tagline": "Power for days",
          "description":
              "20000mAh capacity portable battery with fast charging",
          "price": "49",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1609091839311-d5365f9ff1c5?w=400&h=400&fit=crop",
          "specs": {
            "Capacity": "20000mAh",
            "Output": "USB-C PD 20W",
            "Ports": "2x USB, 1x USB-C",
            "Charging Time": "4.5 hours",
          },
        },
        {
          "id": 20,
          "name": "Roborock S8 Pro Ultra",
          "tagline": "Hands-free cleaning",
          "description":
              "Robot vacuum with automatic mop washing and self-emptying",
          "price": "1599",
          "currency": "USD",
          "image":
              "https://images.unsplash.com/photo-1558317374-067fb5f30001?w=400&h=400&fit=crop",
          "specs": {
            "Suction": "6000Pa",
            "Mop": "VibraRise 2.0",
            "Mapping": "3D Reactive",
            "Battery": "180 minutes",
          },
        },
      ],
    };

    return ProductsModel.fromJson(staticData);
  }
}
