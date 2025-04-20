import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class DestinationService {
  // Change this to your deployed API URL
  final String baseUrl =
      'http://192.168.122.68:5000'; // Use this for Android emulator
  // Use 'http://localhost:5000' for iOS simulator
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

  Future<List<Map<String, dynamic>>> getRecommendations(
    String season, {
    int count = 5,
  }) async {
    try {
      // First, check if the API is responsive
      bool isConnected = await testApiConnection();
      if (!isConnected) {
        throw Exception(
          'Could not connect to recommendation service. Server may be down.',
        );
      }

      final url = Uri.parse(
        '$baseUrl/api/recommend?season=$season&count=$count',
      );
      print('Requesting recommendations from: $url');

      final response = await http.get(url).timeout(Duration(seconds: 15));

      print('Response status: ${response.statusCode}');
      print(
        'Response body preview: ${response.body.substring(0, min(100, response.body.length))}...',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          List<dynamic> recommendationsJson = data['recommendations'];
          print('Parsed ${recommendationsJson.length} recommendations');

          List<Map<String, dynamic>> recommendations =
              recommendationsJson
                  .map(
                    (item) => {
                      'name': item['name'] ?? 'Unknown',
                      'country': item['country'] ?? '',
                      'description': item['description'] ?? '',
                      'rating': item['rating'] ?? 4.0,
                      'type': item['type'] ?? '',
                      'season': item['season'] ?? season,
                      // Generate a color based on the name of the destination
                      'color': _generateColor(item['name'] ?? 'Unknown'),
                    },
                  )
                  .toList();

          return recommendations;
        } else {
          print('API returned success=false: ${data['error']}');
          throw Exception('Failed to load recommendations: ${data['error']}');
        }
      } else {
        print('API returned error status code: ${response.statusCode}');
        throw Exception(
          'Failed to load recommendations: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching recommendations: $e');
      // Rethrow with clearer message
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
  Future<List<Map<String, dynamic>>> getRecommendationsWithFallback(
    String season, {
    int count = 5,
  }) async {
    try {
      return await getRecommendations(season, count: count);
    } catch (e) {
      print('Trying alternative server address...');

      // Try with your computer's actual IP address as fallback
      final originalBaseUrl = baseUrl;

      // Try localhost directly (might work in some configurations)
      final alternativeUrls = [
        'http://localhost:5000',
        'http://127.0.0.1:5000',
        // Add your actual computer's IP here
        // 'http://192.168.1.X:5000'
      ];

      for (String altUrl in alternativeUrls) {
        try {
          print('Trying alternative URL: $altUrl');
          // Temporarily change the base URL
          (this as dynamic).baseUrl = altUrl;

          final result = await getRecommendations(season, count: count);
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
