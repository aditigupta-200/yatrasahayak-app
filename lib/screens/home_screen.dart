import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayak_app/theme/theme_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:yatrasahayak_app/widgets/feature_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Featured destinations data
  final List<Map<String, dynamic>> _featuredDestinations = [
    {
      'name': 'Bali',
      'country': 'Indonesia',
      'image': 'assets/images/bali.jpg',
      'rating': 4.8,
    },
    {
      'name': 'Santorini',
      'country': 'Greece',
      'image': 'assets/images/santorini.jpg',
      'rating': 4.9,
    },
    {
      'name': 'Kyoto',
      'country': 'Japan',
      'image': 'assets/images/kyoto.jpg',
      'rating': 4.7,
    },
  ];

  // Season recommendations
  final List<Map<String, dynamic>> _seasonRecommendations = [
    {'season': 'Spring', 'icon': Icons.eco_rounded, 'color': Color(0xFF7ED957)},
    {
      'season': 'Summer',
      'icon': Icons.wb_sunny_rounded,
      'color': Color(0xFFFF8A48),
    },
    {
      'season': 'Autumn',
      'icon': Icons.forest_rounded,
      'color': Color(0xFFE17B77),
    },
    {
      'season': 'Winter',
      'icon': Icons.ac_unit_rounded,
      'color': Color(0xFF5DA7DB),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: Row(
                children: [
                  Text(
                    'YatraSahayak',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.flight_takeoff,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                ],
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
                    Icons.notifications_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {},
                ),
                SizedBox(width: 8),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
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
                                hintText: 'Where do you want to go?',
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

                    // Featured destinations list (replacing carousel)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Featured Destinations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _featuredDestinations.length,
                            itemBuilder: (context, index) {
                              final destination = _featuredDestinations[index];
                              return Container(
                                width: 160,
                                margin: EdgeInsets.only(
                                  right:
                                      index == _featuredDestinations.length - 1
                                          ? 0
                                          : 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.landscape,
                                          size: 60,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            destination['name'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 14,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                destination['country'],
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    // Season Recommendations Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discover by Season',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Season cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:
                          _seasonRecommendations.map((season) {
                            return InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: season['color'].withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        season['icon'],
                                        color: season['color'],
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    season['season'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onBackground,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),

                    SizedBox(height: 30),

                    // App Features Section
                    Text(
                      'Plan Your Journey',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),

                    SizedBox(height: 16),

                    // Feature cards
                    Row(
                      children: [
                        Expanded(
                          child: FeatureCard(
                            icon: Icons.explore_rounded,
                            title: 'Destinations',
                            subtitle: 'Find perfect places',
                            color: Theme.of(context).colorScheme.primary,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: FeatureCard(
                            icon: Icons.analytics_rounded,
                            title: 'Statistics',
                            subtitle: 'Traveler counts',
                            color: Theme.of(context).colorScheme.secondary,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: FeatureCard(
                            icon: Icons.map_rounded,
                            title: 'Itinerary',
                            subtitle: 'Plan your trip',
                            color: Theme.of(context).colorScheme.tertiary,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: FeatureCard(
                            icon: Icons.travel_explore_rounded,
                            title: 'Experiences',
                            subtitle: 'Unique activities',
                            color: Color(0xFFAC6DDE),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
