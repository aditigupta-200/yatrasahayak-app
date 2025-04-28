import 'dart:convert';
import 'package:http/http.dart' as http;

class TourismPredictionService {
  // Use the same base URL as your DestinationService
  String baseUrl =
      // 'http://192.168.11.29:5000'; // Made this non-final so it can be changed
      'https://ys-final.onrender.com';

  Future<Map<String, dynamic>> getTourismPrediction(
    String destination, {
    int year = 2025,
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/api/tourism-prediction?destination=$destination&year=$year',
      );
      print('Requesting tourism prediction from: $url');

      final response = await http.get(url).timeout(Duration(seconds: 15));

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          print('Successfully retrieved tourism prediction');
          return data['prediction'];
        } else {
          print('API returned success=false: ${data['error']}');
          throw Exception('Failed to load prediction: ${data['error']}');
        }
      } else {
        print('API returned error status code: ${response.statusCode}');
        throw Exception(
          'Failed to load prediction: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching tourism prediction: $e');
      throw Exception('Failed to load tourism prediction: $e');
    }
  }

  // Try alternative server address if the primary one fails
  Future<Map<String, dynamic>> getTourismPredictionWithFallback(
    String destination, {
    int year = 2025,
  }) async {
    try {
      return await getTourismPrediction(destination, year: year);
    } catch (e) {
      print('Trying alternative server address for tourism prediction...');

      // Save original URL
      final originalBaseUrl = baseUrl;

      // Try localhost directly (might work in some configurations)
      final alternativeUrls = [
        'https://ys-final.onrender.com',
        // 'http://127.0.0.1:5000',
        // Add your actual computer's IP here if different
        // 'http://192.168.1.100:5000',
      ];

      for (String altUrl in alternativeUrls) {
        try {
          print('Trying alternative URL: $altUrl');
          // Directly change the base URL (no casting needed)
          baseUrl = altUrl;

          final result = await getTourismPrediction(destination, year: year);
          print('Alternative URL worked: $altUrl');
          return result;
        } catch (altError) {
          print('Alternative URL failed: $altError');
        }
      }

      // Reset to original URL
      baseUrl = originalBaseUrl;

      // If all alternatives fail, return a default response with dummy data
      print('All connection attempts failed, returning mock data');
      return {
        'destination': destination,
        'year': year,
        'predicted_tourists': 125000,
        'growth_rate': 5.2,
        'historical_data': {
          '2017': {'domestic': 75000, 'foreign': 25000, 'total': 100000},
          '2018': {'domestic': 80000, 'foreign': 30000, 'total': 110000},
        },
      };
    }
  }

  Future<Map<String, dynamic>> searchDestinations(String query) async {
    try {
      final url = Uri.parse(
        '$baseUrl/api/search-destinations?query=${Uri.encodeComponent(query)}',
      );

      final response = await http.get(url).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to search destinations');
      }
    } catch (e) {
      throw Exception('Error searching destinations: $e');
    }
  }
}
