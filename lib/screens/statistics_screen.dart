import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayak_app/theme/theme_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  String _selectedView = 'Monthly';

  // Sample tourist data - moved to a separate method for lazy loading
  Map<String, List<Map<String, dynamic>>> get _touristData => {
    'Monthly': [
      {'name': 'Jan', 'count': 25420, 'previousCount': 22340},
      {'name': 'Feb', 'count': 28560, 'previousCount': 24780},
      {'name': 'Mar', 'count': 31250, 'previousCount': 28900},
      {'name': 'Apr', 'count': 34780, 'previousCount': 32450},
      {'name': 'May', 'count': 38900, 'previousCount': 35600},
      {'name': 'Jun', 'count': 45670, 'previousCount': 40200},
      {'name': 'Jul', 'count': 52340, 'previousCount': 48300},
      {'name': 'Aug', 'count': 49760, 'previousCount': 45800},
      {'name': 'Sep', 'count': 42350, 'previousCount': 38900},
      {'name': 'Oct', 'count': 36780, 'previousCount': 34200},
      {'name': 'Nov', 'count': 31240, 'previousCount': 28700},
      {'name': 'Dec', 'count': 38900, 'previousCount': 35400},
    ],
    'Seasonal': [
      {'name': 'Spring', 'count': 94590, 'previousCount': 86130},
      {'name': 'Summer', 'count': 147770, 'previousCount': 134300},
      {'name': 'Autumn', 'count': 110370, 'previousCount': 101800},
      {'name': 'Winter', 'count': 95560, 'previousCount': 86440},
    ],
    'Regional': [
      {'name': 'Asia', 'count': 162450, 'previousCount': 147800},
      {'name': 'Europe', 'count': 124780, 'previousCount': 114500},
      {'name': 'Americas', 'count': 98630, 'previousCount': 89700},
      {'name': 'Oceania', 'count': 32450, 'previousCount': 28900},
      {'name': 'Africa', 'count': 29980, 'previousCount': 26770},
    ],
  };

  // Top destinations data - moved to a separate method for lazy loading
  List<Map<String, dynamic>> get _topDestinations => [
    {
      'name': 'Bali',
      'country': 'Indonesia',
      'growth': 24.5,
      'color': Color(0xFF3B82F6),
    },
    {
      'name': 'Santorini',
      'country': 'Greece',
      'growth': 18.7,
      'color': Color(0xFFF59E0B),
    },
    {
      'name': 'Kyoto',
      'country': 'Japan',
      'growth': 15.2,
      'color': Color(0xFFEC4899),
    },
    {
      'name': 'Prague',
      'country': 'Czech Republic',
      'growth': 12.8,
      'color': Color(0xFF10B981),
    },
    {
      'name': 'Barcelona',
      'country': 'Spain',
      'growth': 10.4,
      'color': Color(0xFF8B5CF6),
    },
  ];

  @override
  bool get wantKeepAlive => true; // Keep the state alive when switching tabs

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              _selectedView = 'Monthly';
              break;
            case 1:
              _selectedView = 'Seasonal';
              break;
            case 2:
              _selectedView = 'Regional';
              break;
          }
        });
      }
    });

    // Force layout calculation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: Text(
                'Tourism Statistics',
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
                    Icons.calendar_today_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {},
                ),
                SizedBox(width: 8),
              ],
            ),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),

                  // Statistics summary card
                  _buildSummaryCard(context),

                  SizedBox(height: 24),

                  // Tabs for different views
                  _buildTabBar(context, isDarkMode),

                  SizedBox(height: 24),

                  // Title with icon
                  _buildViewTitle(context, isDarkMode),

                  SizedBox(height: 16),

                  // Chart view
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 240,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildChart('Monthly'),
                        _buildChart('Seasonal'),
                        _buildChart('Regional'),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Top Destinations Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top Growing Destinations',
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
                  ),

                  SizedBox(height: 12),
                ],
              ),
            ),

            // Top destinations list - using SliverList for better performance
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final destination = _topDestinations[index];
                  return _buildDestinationItem(
                    context,
                    destination,
                    index,
                    isDarkMode,
                  );
                }, childCount: _topDestinations.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the summary card
  Widget _buildSummaryCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Tourists (2024)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+15.2%',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '448,290',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  'visitors',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Domestic', '246,580', '58%'),
              _buildStatItem('International', '201,710', '42%'),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build the tab bar
  Widget _buildTabBar(BuildContext context, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: isDarkMode ? Colors.grey[400] : Colors.grey[700],
        tabs: [
          Tab(text: 'Monthly'),
          Tab(text: 'Seasonal'),
          Tab(text: 'Regional'),
        ],
      ),
    );
  }

  // Helper method to build the view title
  Widget _buildViewTitle(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getViewIcon(_selectedView),
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_selectedView Tourism Trends',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Current year vs previous year',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build destination item
  Widget _buildDestinationItem(
    BuildContext context,
    Map<String, dynamic> destination,
    int index,
    bool isDarkMode,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black12 : Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: destination['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: destination['color'],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  destination['country'],
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '+${destination['growth']}%',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for stat items
  Widget _buildStatItem(String title, String value, String percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9)),
        ),
        SizedBox(height: 6),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '($percentage)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Get icon for view type
  IconData _getViewIcon(String view) {
    switch (view) {
      case 'Monthly':
        return Icons.calendar_month_rounded;
      case 'Seasonal':
        return Icons.wb_sunny_rounded;
      case 'Regional':
        return Icons.public_rounded;
      default:
        return Icons.bar_chart_rounded;
    }
  }

  // Build chart based on selected view - memoized with RepaintBoundary for better performance
  Widget _buildChart(String view) {
    final data = _touristData[view] ?? [];

    return RepaintBoundary(
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY:
              view == 'Monthly'
                  ? 60000
                  : (view == 'Seasonal' ? 160000 : 180000),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${data[groupIndex]['name']}\n',
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: '${NumberFormat.compact().format(rod.toY.round())}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value >= 0 && value < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        data[value.toInt()]['name'],
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onBackground.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  String text = '';
                  if (view == 'Monthly') {
                    if (value == 0)
                      text = '0';
                    else if (value == 20000)
                      text = '20K';
                    else if (value == 40000)
                      text = '40K';
                    else if (value == 60000)
                      text = '60K';
                  } else if (view == 'Seasonal') {
                    if (value == 0)
                      text = '0';
                    else if (value == 50000)
                      text = '50K';
                    else if (value == 100000)
                      text = '100K';
                    else if (value == 150000)
                      text = '150K';
                  } else {
                    if (value == 0)
                      text = '0';
                    else if (value == 60000)
                      text = '60K';
                    else if (value == 120000)
                      text = '120K';
                    else if (value == 180000)
                      text = '180K';
                  }

                  return Text(
                    text,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onBackground.withOpacity(0.6),
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.left,
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(
                  context,
                ).colorScheme.onBackground.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(data.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data[index]['previousCount'].toDouble(),
                  color: Theme.of(
                    context,
                  ).colorScheme.onBackground.withOpacity(0.3),
                  width: view == 'Monthly' ? 8 : 16,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
                BarChartRodData(
                  toY: data[index]['count'].toDouble(),
                  color: Theme.of(context).colorScheme.primary,
                  width: view == 'Monthly' ? 16 : 32,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
