import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class Destination {
  final String name;
  final String state;
  final String city;
  final String type;
  final double rating;
  final String season;
  final String description;
  final double entranceFee;
  final double timeNeeded;
  final int reviewsCount;
  final int domesticTourists;
  final int foreignTourists;
  final double growthRateDomestic;
  final double growthRateForeign;
  final int color;

  Destination({
    required this.name,
    required this.state,
    required this.city,
    required this.type,
    required this.rating,
    required this.season,
    required this.description,
    required this.entranceFee,
    required this.timeNeeded,
    required this.reviewsCount,
    required this.domesticTourists,
    required this.foreignTourists,
    required this.growthRateDomestic,
    required this.growthRateForeign,
    required this.color,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['name'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      type: json['type'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      season: json['season'] ?? '',
      description: json['description'] ?? '',
      entranceFee: json['entrance_fee']?.toDouble() ?? 0.0,
      timeNeeded: json['time_needed']?.toDouble() ?? 1.0,
      reviewsCount: json['reviews_count']?.toInt() ?? 0,
      domesticTourists: json['domestic_tourists_2018']?.toInt() ?? 0,
      foreignTourists: json['foreign_tourists_2018']?.toInt() ?? 0,
      growthRateDomestic: json['growth_rate_domestic']?.toDouble() ?? 0.0,
      growthRateForeign: json['growth_rate_foreign']?.toDouble() ?? 0.0,
      color: _generateColor(json['name'] ?? ''),
    );
  }

  static int _generateColor(String name) {
    int hashCode = name.hashCode;
    List<int> colors = [
      0xFFE879F9, // Pink
      0xFF38BDF8, // Sky blue
      0xFF34D399, // Green
      0xFF2DD4BF, // Teal
      0xFFA78BFA, // Purple
      0xFFF97316, // Orange
      0xFFF59E0B, // Amber
      0xFFEF4444, // Red
      0xFF6366F1, // Indigo
      0xFF60A5FA, // Blue
    ];
    return colors[hashCode.abs() % colors.length];
  }
}

class DestinationService {
  // Change this to your deployed API URL
  final String baseUrl =
      // 'http://192.168.11.29:5000'; // Use this for Android emulator
      'https://ys-final.onrender.com';
  // for iOS simulator
  // Use your deployed URL for production

  // Test the API connection before making recommendation requests
  Future<bool> testApiConnection() async {
    try {
      print('Testing API connection to: $baseUrl/api/test');
      final response = await http
          .get(Uri.parse('$baseUrl/api/test'))
          .timeout(Duration(seconds: 10));

      print('Test API response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Test API connection failed: $e');
      return false;
    }
  }

  Future<List<Destination>> getRecommendations(String season) async {
    try {
      bool isConnected = await testApiConnection();
      if (!isConnected) {
        throw Exception('Could not connect to recommendation service.');
      }

      final url = Uri.parse('$baseUrl/api/recommend?season=$season');
      print('Requesting recommendations from: $url');

      final response = await http.get(url).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          List<dynamic> recommendationsJson = data['recommendations'];
          return recommendationsJson
              .map((item) => Destination.fromJson(item))
              .toList();
        } else {
          throw Exception('Failed to load recommendations: ${data['error']}');
        }
      } else {
        throw Exception(
          'Failed to load recommendations: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching recommendations: $e');
      throw Exception('Failed to load recommendations: $e');
    }
  }

  // Generate a consistent color based on the name of the destination
  int _generateColor(String name) {
    int hashCode = name.hashCode;
    // Create a list of Flutter Material colors
    List<int> colors = [
      0xFFE879F9, // Pink
      0xFF38BDF8, // Sky blue
      0xFF34D399, // Green
      0xFF2DD4BF, // Teal
      0xFFA78BFA, // Purple
      0xFFF97316, // Orange
      0xFFF59E0B, // Amber
      0xFFEF4444, // Red
      0xFF6366F1, // Indigo
      0xFF60A5FA, // Blue
    ];

    // Use the hash code to pick a color
    return colors[hashCode.abs() % colors.length];
  }

  // Try alternative server address if the primary one fails
  Future<List<Destination>> getRecommendationsWithFallback(
    String season,
  ) async {
    try {
      return await getRecommendations(season);
    } catch (e) {
      print('Trying alternative server address...');

      // Try with your computer's actual IP address as fallback
      final originalBaseUrl = baseUrl;

      // Try localhost directly (might work in some configurations)
      final alternativeUrls = [
        'https://ys-final.onrender.com',
        'http://127.0.0.1:5000',
        // Add your actual computer's IP here
        'http://192.168.1.X:5000',
      ];

      for (String altUrl in alternativeUrls) {
        try {
          print('Trying alternative URL: $altUrl');
          // Temporarily change the base URL
          (this as dynamic).baseUrl = altUrl;

          final result = await getRecommendations(season);
          print('Alternative URL worked: $altUrl');
          return result;
        } catch (altError) {
          print('Alternative URL failed: $altError');
        }
      }

      // Reset to original URL
      (this as dynamic).baseUrl = originalBaseUrl;

      // If all alternatives fail, return empty list with original error
      throw Exception(
        'Could not connect to recommendation service. Please check network settings.',
      );
    }
  }
}
