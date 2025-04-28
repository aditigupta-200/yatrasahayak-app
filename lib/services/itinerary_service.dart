// lib/services/itinerary_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/itinerary.dart';

class ItineraryService {
  // Update the base URL to use localhost for development
  final String baseUrl =
      'https://ys-final.onrender.com'; // For local development
  // final String baseUrl = 'http://192.168.122.68:5000';  // For production/network access

  // Get similar places based on place type
  Future<List<Map<String, dynamic>>> getSimilarPlaces(String placeType) async {
    try {
      print('Fetching similar places for type: $placeType');
      final response = await http
          .get(Uri.parse('$baseUrl/api/similar-places?type=$placeType'))
          .timeout(Duration(seconds: 30)); // Increased timeout

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          List<dynamic> placesJson = data['recommendations'];
          print('Parsed ${placesJson.length} similar places');

          return placesJson
              .map((place) => place as Map<String, dynamic>)
              .toList();
        } else {
          throw Exception('API returned error: ${data['error']}');
        }
      } else {
        throw Exception(
          'Failed to load similar places: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching similar places: $e');
      throw Exception('Failed to load similar places: $e');
    }
  }

  // Generate itinerary using AI
  Future<Map<String, dynamic>> generateItinerary(
    String destination,
    int days,
  ) async {
    try {
      print('Generating itinerary for $destination ($days days)');
      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/api/generate-itinerary?destination=$destination&days=$days',
            ),
          )
          .timeout(Duration(seconds: 60)); // Longer timeout for AI generation

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          print('Successfully generated itinerary');
          return {
            'destination': data['destination'],
            'days': data['days'],
            'itinerary': data['itinerary'],
          };
        } else {
          throw Exception('API returned error: ${data['error']}');
        }
      } else {
        throw Exception(
          'Failed to generate itinerary: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error generating itinerary: $e');
      throw Exception('Failed to generate itinerary: $e');
    }
  }

  // Generate a shareable link for the itinerary
  Future<String> generateShareableLink(Itinerary itinerary) async {
    try {
      print('Generating shareable link for itinerary');
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/share-itinerary'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'destination': itinerary.destination,
              'days': itinerary.days,
              'content': itinerary.content,
            }),
          )
          .timeout(Duration(seconds: 30));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          print('Successfully generated shareable link');
          return data['shareable_link'];
        } else {
          throw Exception('API returned error: ${data['error']}');
        }
      } else {
        throw Exception(
          'Failed to generate shareable link: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error generating shareable link: $e');
      throw Exception('Failed to generate shareable link: $e');
    }
  }
}
