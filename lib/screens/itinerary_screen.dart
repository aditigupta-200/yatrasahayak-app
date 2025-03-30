import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayak_app/theme/theme_provider.dart';
import 'package:yatrasahayak_app/widgets/feature_card.dart';

class ItineraryScreen extends StatefulWidget {
  @override
  _ItineraryScreenState createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  // Selected values for the form
  String _selectedDestination = 'Bali';
  String _selectedDuration = '3 days';
  String _selectedTravelStyle = 'Adventure';
  double _budgetValue = 500;

  // Sample generated itinerary data
  final Map<String, List<Map<String, dynamic>>> _sampleItinerary = {
    'Day 1': [
      {
        'time': '09:00 AM',
        'activity': 'Arrival and Hotel Check-in',
        'icon': Icons.hotel,
        'details':
            'Welcome to your destination! Get settled in your accommodation.',
      },
      {
        'time': '12:00 PM',
        'activity': 'Local Lunch Experience',
        'icon': Icons.restaurant,
        'details': 'Try authentic local cuisine at a popular restaurant.',
      },
      {
        'time': '03:00 PM',
        'activity': 'City Orientation Tour',
        'icon': Icons.directions_walk,
        'details': 'Explore the main attractions with a guided walking tour.',
      },
      {
        'time': '07:00 PM',
        'activity': 'Welcome Dinner',
        'icon': Icons.dinner_dining,
        'details':
            'Enjoy a special dinner to celebrate the start of your trip.',
      },
    ],
    'Day 2': [
      {
        'time': '08:00 AM',
        'activity': 'Breakfast at Hotel',
        'icon': Icons.free_breakfast,
        'details': 'Start your day with a nutritious breakfast.',
      },
      {
        'time': '10:00 AM',
        'activity': 'Adventure Activity',
        'icon': Icons.paragliding,
        'details':
            'Experience thrilling outdoor activities perfect for adventure lovers.',
      },
      {
        'time': '02:00 PM',
        'activity': 'Cultural Visit',
        'icon': Icons.museum,
        'details': 'Visit historical sites and immerse in the local culture.',
      },
      {
        'time': '06:00 PM',
        'activity': 'Sunset Viewpoint',
        'icon': Icons.wb_twilight,
        'details': 'Watch a beautiful sunset from a scenic location.',
      },
    ],
    'Day 3': [
      {
        'time': '09:00 AM',
        'activity': 'Nature Excursion',
        'icon': Icons.forest,
        'details': 'Explore natural wonders and scenic landscapes.',
      },
      {
        'time': '01:00 PM',
        'activity': 'Beachside Lunch',
        'icon': Icons.beach_access,
        'details': 'Enjoy a relaxing meal with ocean views.',
      },
      {
        'time': '04:00 PM',
        'activity': 'Souvenir Shopping',
        'icon': Icons.shopping_bag,
        'details': 'Buy mementos and gifts at local markets.',
      },
      {
        'time': '08:00 PM',
        'activity': 'Farewell Dinner',
        'icon': Icons.celebration,
        'details': 'End your trip with a special dining experience.',
      },
    ],
  };

  bool _showItinerary = false;

  // List of sample destinations
  final List<String> _destinations = [
    'Bali',
    'Santorini',
    'Kyoto',
    'Paris',
    'New York',
    'Bangkok',
    'Cairo',
    'Sydney',
  ];

  // List of durations
  final List<String> _durations = [
    '1 day',
    '2 days',
    '3 days',
    '5 days',
    '7 days',
    '10 days',
    '14 days',
  ];

  // List of travel styles
  final List<String> _travelStyles = [
    'Adventure',
    'Relaxation',
    'Cultural',
    'Culinary',
    'Budget',
    'Luxury',
    'Family',
    'Solo',
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
                    'Itinerary Creator',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.map_outlined,
                    color: Theme.of(context).colorScheme.tertiary,
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
                SizedBox(width: 8),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_showItinerary) ...[
                      _buildItineraryForm(context, isDarkMode),
                    ] else ...[
                      _buildGeneratedItinerary(context, isDarkMode),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItineraryForm(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Intro card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.primary,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.flight_takeoff, color: Colors.white, size: 32),
              SizedBox(height: 12),
              Text(
                'Create Your Perfect Journey',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Fill out the details below and we\'ll generate a customized itinerary for your trip.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24),

        Text(
          'Trip Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),

        SizedBox(height: 16),

        // Destination Dropdown
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDestination,
                    isExpanded: true,
                    hint: Text('Select Destination'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                    ),
                    dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    items:
                        _destinations.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDestination = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Duration Dropdown
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: Theme.of(context).colorScheme.secondary,
              ),
              SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDuration,
                    isExpanded: true,
                    hint: Text('Trip Duration'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                    ),
                    dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    items:
                        _durations.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDuration = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Travel Style Dropdown
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Icon(
                Icons.interests_rounded,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTravelStyle,
                    isExpanded: true,
                    hint: Text('Travel Style'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                    ),
                    dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    items:
                        _travelStyles.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedTravelStyle = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24),

        // Budget Slider
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Color(0xFFAC6DDE),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Daily Budget (USD)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '\$100',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _budgetValue,
                    min: 100,
                    max: 1000,
                    divisions: 9,
                    activeColor: Color(0xFFAC6DDE),
                    inactiveColor: Color(0xFFAC6DDE).withOpacity(0.2),
                    label: '\$${_budgetValue.round()}',
                    onChanged: (newValue) {
                      setState(() {
                        _budgetValue = newValue;
                      });
                    },
                  ),
                ),
                Text(
                  '\$1000',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 32),

        // Generate Itinerary Button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _showItinerary = true;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, size: 20),
                SizedBox(width: 8),
                Text(
                  'Generate Itinerary',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),

        SizedBox(height: 24),

        // Travel tips
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isDarkMode
                    ? Colors.grey[800]!.withOpacity(0.4)
                    : Colors.grey[100]!.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Travel Tip',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'For the best experience, consider the season you\'re traveling in. Different destinations offer unique experiences throughout the year.',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGeneratedItinerary(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Itinerary header
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.tertiary,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.map_rounded, color: Colors.white, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Your Trip to $_selectedDestination',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _buildItineraryDetailChip(
                    Icons.calendar_today_rounded,
                    _selectedDuration,
                  ),
                  SizedBox(width: 12),
                  _buildItineraryDetailChip(
                    Icons.interests_rounded,
                    _selectedTravelStyle,
                  ),
                  SizedBox(width: 12),
                  _buildItineraryDetailChip(
                    Icons.account_balance_wallet_rounded,
                    '\$${_budgetValue.round()}/day',
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 20),

        // Back button and share/save actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _showItinerary = false;
                });
              },
              icon: Icon(Icons.arrow_back_rounded, size: 18),
              label: Text('Back'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.ios_share_rounded),
                  tooltip: 'Share',
                  color: Theme.of(context).colorScheme.primary,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.save_alt_rounded),
                  tooltip: 'Save',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 24),

        // Day-by-day itinerary
        ..._sampleItinerary.entries.map((entry) {
          String day = entry.key;
          List<Map<String, dynamic>> activities = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.tertiary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    day,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
              ),
              ...activities.map((activity) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _getRandomColor(context).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                activity['icon'],
                                color: _getRandomColor(context),
                                size: 24,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity['time'],
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  activity['activity'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  activity['details'],
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: 16),
            ],
          );
        }).toList(),

        // Final notes section
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isDarkMode
                    ? Colors.grey[800]!.withOpacity(0.4)
                    : Colors.grey[100]!,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trip Notes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• This itinerary is customized based on your $_selectedTravelStyle preferences.\n'
                '• All activities are within your daily budget of \$${_budgetValue.round()}.\n'
                '• Times are flexible and can be adjusted as needed.\n'
                '• Consider local transportation options between activities.',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24),

        // Edit itinerary button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              // Implementation for editing itinerary
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit_outlined, size: 20),
                SizedBox(width: 8),
                Text(
                  'Customize Itinerary',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),

        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildItineraryDetailChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRandomColor(BuildContext context) {
    List<Color> colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Color(0xFFAC6DDE),
    ];
    return colors[DateTime.now().millisecond % colors.length];
  }
}
