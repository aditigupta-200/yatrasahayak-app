import 'package:flutter/material.dart';
import '../services/destination_service.dart';
import 'package:intl/intl.dart';

class DestinationDetailScreen extends StatelessWidget {
  final Destination destination;

  const DestinationDetailScreen({Key? key, required this.destination})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(destination.name), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Color(destination.color),
              child: Center(
                child: Icon(Icons.place, size: 64, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        destination.rating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        ' (${(destination.reviewsCount / 1000).toStringAsFixed(1)}K reviews)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow(
                    'Location',
                    '${destination.city}, ${destination.state}',
                  ),
                  _buildInfoRow('Type', destination.type),
                  _buildInfoRow('Best Season', destination.season),
                  _buildInfoRow(
                    'Time Needed',
                    '${destination.timeNeeded} hours',
                  ),
                  _buildInfoRow(
                    'Entrance Fee',
                    destination.entranceFee > 0
                        ? '₹${destination.entranceFee.toStringAsFixed(0)}'
                        : 'Free',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(destination.description),
                  SizedBox(height: 16),
                  Text(
                    'Tourism Statistics (2018)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  _buildStatisticRow(
                    'Domestic Tourists',
                    destination.domesticTourists,
                    destination.growthRateDomestic,
                  ),
                  _buildStatisticRow(
                    'Foreign Tourists',
                    destination.foreignTourists,
                    destination.growthRateForeign,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildStatisticRow(String label, int count, double growthRate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              Text(
                NumberFormat.compact().format(count),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              _buildGrowthRate(growthRate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthRate(double rate) {
    final color = rate >= 0 ? Colors.green : Colors.red;
    final icon = rate >= 0 ? Icons.arrow_upward : Icons.arrow_downward;
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        Text(
          '${rate.abs().toStringAsFixed(1)}%',
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}
