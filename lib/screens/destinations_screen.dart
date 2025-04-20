
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayak_app/theme/theme_provider.dart';
import 'package:yatrasahayak_app/services/destination_service.dart';

class DestinationsScreen extends StatefulWidget {
  @override
  _DestinationsScreenState createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> with SingleTickerProviderStateMixin {
  String _selectedSeason = 'Summer';
  late TabController _tabController;
  
  // Create an instance of the destination service
  final DestinationService _destinationService = DestinationService();
  
  // Map to store fetched recommendations for each season
  Map<String, List<Map<String, dynamic>>> _destinationsBySeason = {
    'Spring': [],
    'Summer': [],
    'Autumn': [],
    'Winter': [],
  };
  
  // Loading states for each season
  Map<String, bool> _isLoading = {
    'Spring': false,
    'Summer': false,
    'Autumn': false,
    'Winter': false,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          }
        });
        // Fetch recommendations for the newly selected season
        _fetchRecommendations(_selectedSeason);
      }
    });
    
    // Default to Summer tab
    _tabController.animateTo(1);
    
    // Fetch recommendations for the default season (Summer)
    _fetchRecommendations('Summer');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  // Fetch recommendations from the API
  Future<void> _fetchRecommendations(String season) async {
    // Skip if we already have data or are currently loading
    if (_destinationsBySeason[season]!.isNotEmpty || _isLoading[season]!) {
      return;
    }
    
    setState(() {
      _isLoading[season] = true;
    });
    
    try {
      final recommendations = await _destinationService.getRecommendations(season, count: 5);
      
      setState(() {
        _destinationsBySeason[season] = recommendations;
        _isLoading[season] = false;
      });
    } catch (e) {
      print('Error fetching recommendations: $e');
      setState(() {
        _isLoading[season] = false;
        // Set default values in case of error
        _destinationsBySeason[season] = [
          {
            'name': 'Error loading destinations',
            'country': 'Please try again later',
            'description': 'Could not connect to the recommendation service.',
            'rating': 0.0,
            'color': Color(0xFFE53935),
          }
        ];
      });
    }
  }

  // Get season icon
  IconData _getSeasonIcon(String season) {
    // Existing code remains the same
    switch (season) {
      case 'Spring':
        return Icons.eco_rounded;
      case 'Summer':
        return Icons.wb_sunny_rounded;
      case 'Autumn':
        return Icons.forest_rounded;
      case 'Winter':
        return Icons.ac_unit_rounded;
      default:
        return Icons.landscape_rounded;
    }
  }

  // Get season color
  Color _getSeasonColor(String season) {
    // Existing code remains the same
    switch (season) {
      case 'Spring':
        return Color(0xFF7ED957);
      case 'Summer':
        return Color(0xFFFF8A48);
      case 'Autumn':
        return Color(0xFFE17B77);
      case 'Winter':
        return Color(0xFF5DA7DB);
      default:
        return Color(0xFF5D69BE);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Existing build method remains largely unchanged
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final seasonColor = _getSeasonColor(_selectedSeason);

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            // Existing code remains the same
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
                  IconButton(
                    icon: Icon(
                      Icons.filter_list_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {},
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
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
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

              // Destinations list with TabBarView
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDestinationsList('Spring'),
                    _buildDestinationsList('Summer'),
                    _buildDestinationsList('Autumn'),
                    _buildDestinationsList('Winter'),
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
            CircularProgressIndicator(
              color: _getSeasonColor(season),
            ),
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
    
    // Show empty state if no destinations and not loading
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
                _fetchRecommendations(season);
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
        Color cardColor = destination['color'] is int 
            ? Color(destination['color']) 
            : Color(0xFF38BDF8); // Default color
            
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
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cardColor,
                        cardColor.withOpacity(0.8),
                      ],
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
                              Icon(
                                Icons.star, 
                                color: Colors.amber, 
                                size: 16
                              ),
                              SizedBox(width: 4),
                              Text(
                                destination['rating'].toString(),
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            destination['name'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onBackground,
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
                            destination['country'],
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
                        destination['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
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
                              onPressed: () {},
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
            )],
            ),
          ),
        );
      },
    );
  }
}