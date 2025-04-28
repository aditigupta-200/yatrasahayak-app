// lib/models/itinerary.dart
class Itinerary {
  final String destination;
  final int days;
  final String content;

  Itinerary({
    required this.destination,
    required this.days,
    required this.content,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      destination: json['destination'] ?? '',
      days: json['days'] ?? 3,
      content: json['itinerary'] ?? '',
    );
  }
}

// We can reuse your existing destination/place model or create a new one
class Place {
  final String name;
  final String country;
  final String description;
  final double rating;
  final String type;
  final String season;
  final double fee;

  Place({
    required this.name,
    this.country = '',
    this.description = '',
    this.rating = 4.5,
    this.type = '',
    this.season = '',
    this.fee = 0,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] ?? 'Unknown',
      country: json['country'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 4.5).toDouble(),
      type: json['type'] ?? '',
      season: json['season'] ?? '',
      fee: (json['fee'] ?? 0).toDouble(),
    );
  }
}
