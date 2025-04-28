import 'dart:convert';
import 'package:http/http.dart' as http;

class TouristStatisticsService {
  // Make this a variable (not final) so it can be changed
  String baseUrl =
      // 'http://192.168.11.29:5000';
      'https://ys-final.onrender.com';

  // Method to set the base URL properly
  void setBaseUrl(String newUrl) {
    baseUrl = newUrl;
  }

  // Get tourism statistics for a destination
  Future<Map<String, dynamic>> getTourismStatistics(
    String destinationName, {
    int targetYear = 2025,
  }) async {
    try {
      // First, check if the API is responsive
      bool isConnected = await testApiConnection();
      if (!isConnected) {
        throw Exception(
          'Could not connect to statistics service. Server may be down.',
        );
      }

      final url = Uri.parse(
        '$baseUrl/api/predict_tourism?destination=${Uri.encodeComponent(destinationName)}&year=$targetYear',
      );
      print('Requesting tourism statistics from: $url');

      final response = await http.get(url).timeout(Duration(seconds: 15));

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          print('Successfully retrieved tourism statistics');
          return data;
        } else {
          print('API returned success=false: ${data['error']}');
          throw Exception(
            'Failed to load tourism statistics: ${data['error']}',
          );
        }
      } else {
        print('API returned error status code: ${response.statusCode}');
        throw Exception(
          'Failed to load tourism statistics: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching tourism statistics: $e');
      throw Exception('Failed to load tourism statistics: $e');
    }
  }

  // Test the API connection
  Future<bool> testApiConnection() async {
    try {
      print('Testing API connection to: $baseUrl/api/test');
      final response = await http
          .get(Uri.parse('$baseUrl/api/test'))
          .timeout(Duration(seconds: 10));

      print('Test API response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Test API connection failed: $e');
      return false;
    }
  }

  // Try alternative server address if the primary one fails
  Future<Map<String, dynamic>> getTourismStatisticsWithFallback(
    String destinationName, {
    int targetYear = 2025,
  }) async {
    try {
      return await getTourismStatistics(
        destinationName,
        targetYear: targetYear,
      );
    } catch (e) {
      print('Trying alternative server addresses...');

      // Store original URL to restore it later
      final originalBaseUrl = baseUrl;

      // Try with alternative addresses as fallback
      final alternativeUrls = [
        'https://ys-final.onrender.com',
        // 'http://127.0.0.1:5000',
        // Add your actual computer's IP here - replace this with your actual IP
        // 'http://192.168.1.100:5000',
      ];

      for (String altUrl in alternativeUrls) {
        try {
          print('Trying alternative URL: $altUrl');
          // Use the setter method instead of dynamic assignment
          setBaseUrl(altUrl);

          final result = await getTourismStatistics(
            destinationName,
            targetYear: targetYear,
          );
          print('Alternative URL worked: $altUrl');
          return result;
        } catch (altError) {
          print('Alternative URL failed: $altError');
        }
      }

      // Reset to original URL
      setBaseUrl(originalBaseUrl);

      // If all alternatives fail, throw an exception with a clear message
      throw Exception(
        'Could not connect to statistics service. Please check network settings.',
      );
    }
  }
}
