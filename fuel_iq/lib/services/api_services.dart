import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for interacting with Open Food Facts API
class OpenFoodFactsService {
  static const String _baseUrl = 'https://world.openfoodfacts.org/api/v2';
  
  /// Fetches product information by barcode
  /// Returns a Map with product data or null if not found
  Future<Map<String, dynamic>?> getProductByBarcode(String barcode) async {
    try {
      final url = Uri.parse('$_baseUrl/product/$barcode');
      
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'YourAppName - Android/iOS - Version 1.0',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Check if product was found
        if (data['status'] == 1) {
          return data['product'];
        } else {
          return null; // Product not found
        }
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Extracts useful information from product data
  ProductInfo parseProductInfo(Map<String, dynamic> product) {
    return ProductInfo(
      productName: product['product_name'] ?? 'Unknown Product',
      brands: product['brands'] ?? 'Unknown Brand',
      quantity: product['quantity'] ?? 'N/A',
      imageUrl: product['image_url'],
      ingredients: product['ingredients_text'] ?? 'No ingredients listed',
      
      // Nutritional information per 100g
      energyKcal: product['nutriments']?['energy-kcal_100g']?.toDouble(),
      proteins: product['nutriments']?['proteins_100g']?.toDouble(),
      carbohydrates: product['nutriments']?['carbohydrates_100g']?.toDouble(),
      sugars: product['nutriments']?['sugars_100g']?.toDouble(),
      fat: product['nutriments']?['fat_100g']?.toDouble(),
      saturatedFat: product['nutriments']?['saturated-fat_100g']?.toDouble(),
      fiber: product['nutriments']?['fiber_100g']?.toDouble(),
      sodium: product['nutriments']?['sodium_100g']?.toDouble(),
      salt: product['nutriments']?['salt_100g']?.toDouble(),
      
      // Scores and grades
      nutriScore: product['nutriscore_grade'],
      novaGroup: product['nova_group']?.toString(),
      ecoscore: product['ecoscore_grade'],
      
      // Categories and labels
      categories: product['categories'] ?? 'N/A',
      labels: product['labels'] ?? 'N/A',
      allergens: product['allergens'] ?? 'None listed',
      
      // Additional info
      barcode: product['code'] ?? '',
    );
  }

  /// Search products by name
  Future<List<Map<String, dynamic>>> searchProducts(
    String searchTerm, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/search?search_terms=$searchTerm&page=$page&page_size=$pageSize&json=true'
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'YourAppName - Android/iOS - Version 1.0',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['products'] ?? []);
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

/// Model class to hold parsed product information
class ProductInfo {
  final String productName;
  final String brands;
  final String quantity;
  final String? imageUrl;
  final String ingredients;
  
  // Nutrition per 100g
  final double? energyKcal;
  final double? proteins;
  final double? carbohydrates;
  final double? sugars;
  final double? fat;
  final double? saturatedFat;
  final double? fiber;
  final double? sodium;
  final double? salt;
  
  // Scores
  final String? nutriScore;
  final String? novaGroup;
  final String? ecoscore;
  
  // Other info
  final String categories;
  final String labels;
  final String allergens;
  final String barcode;

  ProductInfo({
    required this.productName,
    required this.brands,
    required this.quantity,
    this.imageUrl,
    required this.ingredients,
    this.energyKcal,
    this.proteins,
    this.carbohydrates,
    this.sugars,
    this.fat,
    this.saturatedFat,
    this.fiber,
    this.sodium,
    this.salt,
    this.nutriScore,
    this.novaGroup,
    this.ecoscore,
    required this.categories,
    required this.labels,
    required this.allergens,
    required this.barcode,
  });
}