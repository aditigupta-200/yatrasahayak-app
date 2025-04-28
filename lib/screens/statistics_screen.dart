import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/tourism_prediction_service.dart';

class SearchResult {
  final String state;
  final String city;
  final String name;
  final String type;
  final double rating;
  final String season;

  SearchResult({
    required this.state,
    required this.city,
    required this.name,
    required this.type,
    required this.rating,
    required this.season,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      season: json['season'] ?? '',
    );
  }
}

class StatisticsScreen extends StatefulWidget {
  final String? destinationName;

  const StatisticsScreen({Key? key, this.destinationName}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final TourismPredictionService _predictionService =
      TourismPredictionService();
  final TextEditingController _destinationController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  bool _isLoading = true;
  String _errorMessage = '';
  Map<String, dynamic> _predictionData = {};
  int _selectedYear = 2025;
  List<SearchResult> _searchResults = [];
  bool _isSearching = false;

  final List<int> _availableYears = [
    2023,
    2024,
    2025,
    2026,
    2027,
    2028,
    2029,
    2030,
  ];

  @override
  void initState() {
    super.initState();
    _destinationController.text = widget.destinationName ?? '';
    _setupSearchListener();
    if (widget.destinationName != null) {
      _loadPredictionData();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setupSearchListener() {
    _destinationController.addListener(() {
      _debouncer.run(() {
        if (_destinationController.text.trim().isNotEmpty) {
          _searchDestinations(_destinationController.text);
        } else {
          setState(() {
            _searchResults = [];
            _isSearching = false;
          });
        }
      });
    });
  }

  Future<void> _searchDestinations(String query) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final response = await _predictionService.searchDestinations(query);
      if (mounted) {
        setState(() {
          _searchResults =
              (response['results'] as List)
                  .map((result) => SearchResult.fromJson(result))
                  .toList();
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
    }
  }

  void _selectSearchResult(SearchResult result) {
    setState(() {
      _destinationController.text = result.name;
      _searchResults = [];
      _isSearching = false;
    });
    _loadPredictionData();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _loadPredictionData() async {
    if (_destinationController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a destination name';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final data = await _predictionService.getTourismPredictionWithFallback(
        _destinationController.text.trim(),
        year: _selectedYear,
      );

      setState(() {
        _predictionData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tourism Statistics'), elevation: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    hintText: 'Search for a destination...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                ),
                if (_isSearching)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                if (_searchResults.isNotEmpty)
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.only(top: 8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_searchResults.length} results found',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchResults = [];
                                    });
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final result = _searchResults[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        result.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${result.city}, ${result.state}',
                                          ),
                                          Text(
                                            'Type: ${result.type} • Season: ${result.season}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 16,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            result.rating.toStringAsFixed(1),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () => _selectSearchResult(result),
                                    ),
                                    if (index < _searchResults.length - 1)
                                      Divider(height: 1),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _errorMessage.isNotEmpty
                    ? _buildErrorView()
                    : _buildStatisticsView(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Failed to load tourism statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[700]),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadPredictionData,
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Destination',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _destinationController,
                          decoration: InputDecoration(
                            hintText: 'Enter destination name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.place),
                          ),
                          onSubmitted: (_) => _loadPredictionData(),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _loadPredictionData,
                        child: Text('Search'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          if (_predictionData.isNotEmpty) ...[
            _buildYearSelectionCard(),
            SizedBox(height: 16),
            _buildPredictionCard(),
            SizedBox(height: 16),
            if (_predictionData['historical_data'] != null) ...[
              _buildHistoricalDataCard(),
              SizedBox(height: 16),
              _buildTourismTrendCard(),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildYearSelectionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prediction Year',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    value: _selectedYear,
                    items:
                        _availableYears.map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text('$year'),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null && value != _selectedYear) {
                        setState(() {
                          _selectedYear = value;
                        });
                        _loadPredictionData();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionCard() {
    final int predictedTourists = _predictionData['predicted_tourists'] ?? 0;
    final double growthRate = _predictionData['growth_rate'] ?? 0.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatBox(
                'Predicted Tourists',
                _formatNumber(predictedTourists),
                Icons.people,
                Colors.blue,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildStatBox(
                'Average Growth',
                '${growthRate.toStringAsFixed(2)}%',
                Icons.trending_up,
                growthRate >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'This prediction is based on historical data and growth trends. '
          'Actual numbers may vary due to economic conditions, travel restrictions, or other factors.',
          style: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricalDataCard() {
    final historicalData = _predictionData['historical_data'] ?? {};

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historical Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildHistoricalDataTable(historicalData),
          ],
        ),
      ),
    );
  }

  Widget _buildTourismTrendCard() {
    final historicalData = _predictionData['historical_data'] ?? {};

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tourism Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(height: 250, child: _buildTourismChart(historicalData)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricalDataTable(Map<String, dynamic> historicalData) {
    return Table(
      border: TableBorder.all(color: Colors.grey.withOpacity(0.3), width: 1),
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.5),
      },
      children: [
        _buildTableRow([
          'Year',
          'Domestic',
          'Foreign',
          'Total',
        ], isHeader: true),
        ...historicalData.entries.map((entry) {
          final year = entry.key;
          final data = entry.value;
          return _buildTableRow([
            year,
            _formatNumber(data['domestic'] ?? 0),
            _formatNumber(data['foreign'] ?? 0),
            _formatNumber(data['total'] ?? 0),
          ]);
        }).toList(),
        _buildTableRow([
          _selectedYear.toString(),
          'N/A',
          'N/A',
          _formatNumber(_predictionData['predicted_tourists'] ?? 0),
        ], highlight: true),
      ],
    );
  }

  TableRow _buildTableRow(
    List<String> cells, {
    bool isHeader = false,
    bool highlight = false,
  }) {
    Color bgColor = Colors.transparent;
    if (isHeader) {
      bgColor = Colors.grey.withOpacity(0.2);
    } else if (highlight) {
      bgColor = Colors.blue.withOpacity(0.1);
    }

    return TableRow(
      decoration: BoxDecoration(color: bgColor),
      children:
          cells.map((cell) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                cell,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight:
                      isHeader || highlight
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTourismChart(Map<String, dynamic> historicalData) {
    // Create data points for the chart
    final List<FlSpot> spots = [];

    // Add historical data points
    historicalData.forEach((year, data) {
      final x = double.parse(year);
      final y = (data['total'] ?? 0).toDouble();
      spots.add(FlSpot(x, y));
    });

    // Add prediction point
    spots.add(
      FlSpot(
        _selectedYear.toDouble(),
        (_predictionData['predicted_tourists'] ?? 0).toDouble(),
      ),
    );

    // Sort by x-value (year)
    spots.sort((a, b) => a.x.compareTo(b.x));

    // Find min and max for better scaling
    double maxY = 0;
    for (var spot in spots) {
      if (spot.y > maxY) maxY = spot.y;
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatCompactNumber(value),
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        minX: spots.first.x,
        maxX: spots.last.x,
        minY: 0,
        maxY: maxY * 1.2, // Add some margin at the top
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                // Make the prediction point look different
                if (spot.x == _selectedYear) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: Colors.orange,
                  );
                }
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Colors.blue,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.black.withOpacity(0.8),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final year = spot.x.toInt();
                final tourists = spot.y.toInt();

                // Check if this is a prediction point
                final isPrediction = year == _selectedYear;

                return LineTooltipItem(
                  '${isPrediction ? "Prediction for " : ""}$year\n${_formatNumber(tourists)} tourists',
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatCompactNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toInt().toString();
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  dispose() {
    _timer?.cancel();
  }
}
