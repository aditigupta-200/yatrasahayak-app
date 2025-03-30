// File: screens/destinations_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayak_app/theme/theme_provider.dart';

class DestinationsScreen extends StatefulWidget {
  @override
  _DestinationsScreenState createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> with SingleTickerProviderStateMixin {
  String _selectedSeason = 'Summer';
  late TabController _tabController;
  
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
      }
    });
    // Default to Summer tab
    _tabController.animateTo(1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  // Sample destination data
  final Map<String, List<Map<String, dynamic>>> _destinationsBySeason = {
    'Spring': [
      {
        'name': 'Kyoto',
        'country': 'Japan',
        'description': 'Cherry blossoms and traditional gardens',
        'rating': 4.8,
        'color': Color(0xFFE879F9),
      },
      {
        'name': 'Amsterdam',
        'country': 'Netherlands',
        'description': 'Tulip fields and canal cruises',
        'rating': 4.6,
        'color': Color(0xFF38BDF8),
      },
      {
        'name': 'Paris',
        'country': 'France',
        'description': 'Gardens bloom with mild weather',
        'rating': 4.7,
        'color': Color(0xFF34D399),
      },
    ],
    'Summer': [
      {
        'name': 'Santorini',
        'country': 'Greece',
        'description': 'Stunning beaches and white architecture',
        'rating': 4.9,
        'color': Color(0xFF2DD4BF),
      },
      {
        'name': 'Bali',
        'country': 'Indonesia',
        'description': 'Tropical paradise with lush landscapes',
        'rating': 4.7,
        'color': Color(0xFFA78BFA),
      },
      {
        'name': 'Barcelona',
        'country': 'Spain',
        'description': 'Vibrant city with beautiful beaches',
        'rating': 4.8,
        'color': Color(0xFFF97316),
      },
    ],
    'Autumn': [
      {
        'name': 'Kyoto',
        'country': 'Japan',
        'description': 'Brilliant autumn foliage and temples',
        'rating': 4.9,
        'color': Color(0xFFF59E0B),
      },
      {
        'name': 'New England',
        'country': 'USA',
        'description': 'Spectacular fall colors and cozy towns',
        'rating': 4.7,
        'color': Color(0xFFEF4444),
      },
      {
        'name': 'Bavaria',
        'country': 'Germany',
        'description': 'Fairytale castles with autumn colors',
        'rating': 4.6,
        'color': Color(0xFF6366F1),
      },
    ],
    'Winter': [
      {
      'name': 'Lapland',
        'country': 'Finland',
        'description': 'Northern lights and winter activities',
        'rating': 4.8,
        'color': Color(0xFF60A5FA),
      },
      {
        'name': 'Swiss Alps',
        'country': 'Switzerland',
        'description': 'World-class skiing and mountain views',
        'rating': 4.9,
        'color': Color(0xFF8B5CF6),
      },
      {
        'name': 'Prague',
        'country': 'Czech Republic',
        'description': 'Magical Christmas markets and snow',
        'rating': 4.7,
        'color': Color(0xFFF43F5E),
      },
    ],
  };

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
                          'Recommended destinations for this season',
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

              // Destinations list
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
    final destinations = _destinationsBySeason[season] ?? [];
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        final destination = destinations[index];
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
                        destination['color'],
                        destination['color'].withOpacity(0.8),
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
                              Icon(Icons.star, color: Colors.amber, size: 16),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
