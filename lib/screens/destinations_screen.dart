import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayak_app/theme/theme_provider.dart';
import 'package:yatrasahayak_app/services/destination_service.dart';
import 'package:yatrasahayak_app/screens/destination_detail_screen.dart';

class DestinationsScreen extends StatefulWidget {
  final String? initialSeason;

  const DestinationsScreen({Key? key, this.initialSeason}) : super(key: key);

  @override
  _DestinationsScreenState createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedSeason = 'Summer';
  late TabController _tabController;
  final DestinationService _destinationService = DestinationService();

  // Map to store destinations for each season
  Map<String, List<Destination>> _destinationsBySeason = {
    'Spring': [],
    'Summer': [],
    'Autumn': [],
    'Winter': [],
    'Monsoon': [],
  };

  // Loading states for each season
  Map<String, bool> _isLoading = {
    'Spring': false,
    'Summer': false,
    'Autumn': false,
    'Winter': false,
    'Monsoon': false,
  };

  // Error states for each season
  Map<String, String> _errors = {
    'Spring': '',
    'Summer': '',
    'Autumn': '',
    'Winter': '',
    'Monsoon': '',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              _selectedSeason = 'Spring';
              break;
            case 1:
              _selectedSeason = 'Summer';
              break;
            case 2:
              _selectedSeason = 'Autumn';
              break;
            case 3:
              _selectedSeason = 'Winter';
              break;
            case 4:
              _selectedSeason = 'Monsoon';
              break;
          }
        });
        // Fetch recommendations for the newly selected season
        _loadDestinations(_selectedSeason);
      }
    });

    // Set initial season if provided
    if (widget.initialSeason != null) {
      switch (widget.initialSeason) {
        case 'Spring':
          _tabController.animateTo(0);
          _selectedSeason = 'Spring';
          break;
        case 'Summer':
          _tabController.animateTo(1);
          _selectedSeason = 'Summer';
          break;
        case 'Autumn':
          _tabController.animateTo(2);
          _selectedSeason = 'Autumn';
          break;
        case 'Winter':
          _tabController.animateTo(3);
          _selectedSeason = 'Winter';
          break;
        case 'Monsoon':
          _tabController.animateTo(4);
          _selectedSeason = 'Monsoon';
          break;
      }
    } else {
      // Default to Summer tab
      _tabController.animateTo(1);
    }

    // Fetch recommendations for the initial season
    _loadDestinations(_selectedSeason);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDestinations(String season) async {
    // Skip if we already have data or are currently loading
    if (_destinationsBySeason[season]!.isNotEmpty || _isLoading[season]!) {
      return;
    }

    setState(() {
      _isLoading[season] = true;
      _errors[season] = '';
    });

    try {
      final destinations = await _destinationService.getRecommendations(season);
      setState(() {
        _destinationsBySeason[season] = destinations;
        _isLoading[season] = false;
      });
    } catch (e) {
      setState(() {
        _errors[season] = e.toString();
        _isLoading[season] = false;
      });
    }
  }

  // Get season icon
  IconData _getSeasonIcon(String season) {
    switch (season) {
      case 'Spring':
        return Icons.eco_rounded;
      case 'Summer':
        return Icons.wb_sunny_rounded;
      case 'Autumn':
        return Icons.forest_rounded;
      case 'Winter':
        return Icons.ac_unit_rounded;
      case 'Monsoon':
        return Icons.water_drop_rounded;
      default:
        return Icons.landscape_rounded;
    }
  }

  // Get season color
  Color _getSeasonColor(String season) {
    switch (season) {
      case 'Spring':
        return Color(0xFF7ED957);
      case 'Summer':
        return Color(0xFFFF8A48);
      case 'Autumn':
        return Color(0xFFE17B77);
      case 'Winter':
        return Color(0xFF5DA7DB);
      case 'Monsoon':
        return Color(0xFF3D9970);
      default:
        return Color(0xFF5D69BE);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final seasonColor = _getSeasonColor(_selectedSeason);

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                title: Text(
                  'Explore Destinations',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ];
          },
          body: Column(
            children: [
              SizedBox(height: 8),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isDarkMode
                              ? Colors.black12
                              : Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search destinations...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color:
                                isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Season tabs
              Container(
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: seasonColor,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor:
                      isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.eco_rounded),
                            SizedBox(width: 8),
                            Text('Spring'),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wb_sunny_rounded),
                            SizedBox(width: 8),
                            Text('Summer'),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.forest_rounded),
                            SizedBox(width: 8),
                            Text('Autumn'),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.ac_unit_rounded),
                            SizedBox(width: 8),
                            Text('Winter'),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.water_drop_rounded),
                            SizedBox(width: 8),
                            Text('Monsoon'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Season title with icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: seasonColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getSeasonIcon(_selectedSeason),
                        color: seasonColor,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Best for $_selectedSeason',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ML Recommended destinations for this season',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Destinations list with TabBarView for swipe gesture
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDestinationsList('Spring'),
                    _buildDestinationsList('Summer'),
                    _buildDestinationsList('Autumn'),
                    _buildDestinationsList('Winter'),
                    _buildDestinationsList('Monsoon'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationsList(String season) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final destinations = _destinationsBySeason[season] ?? [];

    // Show loading indicator while fetching data
    if (_isLoading[season]!) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: _getSeasonColor(season)),
            SizedBox(height: 16),
            Text(
              'Finding best $season destinations...',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // Show error state
    if (_errors[season]!.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
            SizedBox(height: 16),
            Text(
              'Error loading destinations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[300],
              ),
            ),
            SizedBox(height: 8),
            Text(
              _errors[season]!,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _loadDestinations(season);
              },
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getSeasonColor(season),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Show empty state if no destinations
    if (destinations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.travel_explore,
              size: 60,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            SizedBox(height: 16),
            Text(
              'No destinations available for $season',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                _loadDestinations(season);
              },
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getSeasonColor(season),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Show destination cards
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        final destination = destinations[index];
        Color cardColor = Color(destination.color);

        return Container(
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color:
                    isDarkMode
                        ? Colors.black12
                        : Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DestinationDetailScreen(
                              destination: destination,
                            ),
                      ),
                    );
                  },
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [cardColor, cardColor.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.landscape_rounded,
                            size: 60,
                            color: Colors.white70,
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  destination.rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              destination.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getSeasonColor(season).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getSeasonIcon(season),
                                  color: _getSeasonColor(season),
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  season,
                                  style: TextStyle(
                                    color: _getSeasonColor(season),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color:
                                isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${destination.city}, ${destination.state}',
                            style: TextStyle(
                              color:
                                  isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        destination.description ??
                            'Explore this beautiful destination in ${destination.state} during $season season.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text('Add to Wishlist'),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DestinationDetailScreen(
                                          destination: destination,
                                        ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text('View Details'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
