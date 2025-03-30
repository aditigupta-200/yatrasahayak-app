import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayak_app/theme/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Sample user data
  final Map<String, dynamic> _userData = {
    'name': 'Aryan Sharma',
    'email': 'aryan.sharma@example.com',
    'location': 'New Delhi, India',
    'memberSince': 'March 2024',
    'tripCount': 8,
    'preferences': ['Adventure', 'Cultural', 'Budget-friendly'],
    'savedDestinations': ['Bali', 'Santorini', 'Manali', 'Goa'],
  };

  // Settings options
  final List<Map<String, dynamic>> _settingsOptions = [
    {
      'title': 'Account Settings',
      'icon': Icons.person_outline,
      'color': Color(0xFF5DA7DB),
    },
    {
      'title': 'Travel Preferences',
      'icon': Icons.favorite_border,
      'color': Color(0xFFE17B77),
    },
    {
      'title': 'Notifications',
      'icon': Icons.notifications_none_rounded,
      'color': Color(0xFFFF8A48),
    },
    {
      'title': 'Privacy & Security',
      'icon': Icons.security_outlined,
      'color': Color(0xFF7ED957),
    },
    {
      'title': 'Help & Support',
      'icon': Icons.help_outline_rounded,
      'color': Color(0xFFAC6DDE),
    },
  ];

  // Achievement badges
  final List<Map<String, dynamic>> _achievements = [
    {
      'icon': Icons.public,
      'title': 'Globetrotter',
      'description': 'Visited 3+ countries',
    },
    {
      'icon': Icons.camera_alt,
      'title': 'Photographer',
      'description': 'Shared 10+ photos',
    },
    {
      'icon': Icons.star,
      'title': 'Top Reviewer',
      'description': 'Posted 5+ reviews',
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
                    'Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.verified_user,
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
                    Icons.edit_outlined,
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
                    // Profile Header
                    _buildProfileHeader(context, isDarkMode),

                    SizedBox(height: 24),

                    // Travel Stats
                    _buildTravelStats(context, isDarkMode),

                    SizedBox(height: 24),

                    // Achievements
                    _buildAchievements(context, isDarkMode),

                    SizedBox(height: 24),

                    // Settings sections
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),

                    SizedBox(height: 12),

                    // Settings list
                    ..._settingsOptions.map((option) {
                      return _buildSettingOption(
                        context,
                        option['title'],
                        option['icon'],
                        option['color'],
                        isDarkMode,
                      );
                    }).toList(),

                    SizedBox(height: 16),

                    // App version
                    Center(
                      child: Text(
                        'YatraSahayak v1.0.0',
                        style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Logout button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.logout, size: 18),
                        label: Text('Logout'),
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          foregroundColor:
                              isDarkMode ? Colors.grey[300] : Colors.grey[700],
                          side: BorderSide(
                            color:
                                isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Profile Image
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.7),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.add_a_photo, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // User info
          Text(
            _userData['name'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 4),

          Text(
            _userData['email'],
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),

          SizedBox(height: 8),

          // Location and member info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white.withOpacity(0.8),
                size: 14,
              ),
              SizedBox(width: 4),
              Text(
                _userData['location'],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
              Icon(
                Icons.calendar_today,
                color: Colors.white.withOpacity(0.8),
                size: 14,
              ),
              SizedBox(width: 4),
              Text(
                'Member since ${_userData['memberSince']}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTravelStats(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Travel Stats',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),

        SizedBox(height: 12),

        Row(
          children: [
            _buildStatCard(
              context,
              'Trips',
              _userData['tripCount'].toString(),
              Icons.flight_takeoff,
              Theme.of(context).colorScheme.primary,
              isDarkMode,
            ),
            SizedBox(width: 12),
            _buildStatCard(
              context,
              'Places',
              _userData['savedDestinations'].length.toString(),
              Icons.place,
              Theme.of(context).colorScheme.secondary,
              isDarkMode,
            ),
            SizedBox(width: 12),
            _buildStatCard(
              context,
              'Reviews',
              '5',
              Icons.star,
              Color(0xFFFF8A48),
              isDarkMode,
            ),
          ],
        ),

        SizedBox(height: 20),

        // Travel Preferences Section
        Text(
          'Travel Preferences',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),

        SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              _userData['preferences'].map<Widget>((preference) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    preference,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
        ),

        SizedBox(height: 20),

        // Saved Destinations
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Saved Destinations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12),

        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _userData['savedDestinations'].length,
            itemBuilder: (context, index) {
              final destination = _userData['savedDestinations'][index];
              return Container(
                width: 140,
                margin: EdgeInsets.only(
                  right:
                      index == _userData['savedDestinations'].length - 1
                          ? 0
                          : 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Opacity(
                          opacity: 0.6,
                          child: Icon(
                            Icons.landscape,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                        child: Text(
                          destination,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Achievements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12),

        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _achievements.length,
            itemBuilder: (context, index) {
              final achievement = _achievements[index];
              return Container(
                width: 120,
                margin: EdgeInsets.only(
                  right: index == _achievements.length - 1 ? 0 : 16,
                ),
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? Colors.grey[800]
                          : Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isDarkMode
                            ? Colors.grey[700]!
                            : Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        achievement['icon'],
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      achievement['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      achievement['description'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingOption(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        onTap: () {},
      ),
    );
  }
}
