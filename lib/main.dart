// File: main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayak_app/theme/theme_provider.dart';
import 'package:yatrasahayak_app/screens/home_screen.dart';
import 'package:yatrasahayak_app/screens/destinations_screen.dart';
import 'package:yatrasahayak_app/screens/statistics_screen.dart';
import 'package:yatrasahayak_app/screens/itinerary_screen.dart';
import 'package:yatrasahayak_app/screens/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: YatraSahayakApp(),
    ),
  );
}

class YatraSahayakApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YatraSahayak',
      theme: ThemeData(
        primaryColor: Color(0xFF5D69BE),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF5D69BE),
          secondary: Color(0xFFFF8E6E),
          tertiary: Color(0xFF00C6AE),
          background: Color(0xFFF8F9FA),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF5D69BE),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: Color(0xFF6C63FF),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFFFF7D6B),
          tertiary: Color(0xFF00D1B8),
          background: Color(0xFF121212),
          surface: Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: Color(0xFF121212),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          color: Color(0xFF1E1E1E),
        ),
      ),
      themeMode: themeProvider.themeMode,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  static List<Widget> _screens = <Widget>[
    HomeScreen(),
    DestinationsScreen(),
    StatisticsScreen(),
    ItineraryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    _animationController.reset();
    _animationController.forward();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: FadeTransition(
        opacity: _animationController.drive(
          CurveTween(curve: Curves.easeInOut),
        ),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black26 : Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).colorScheme.surface,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_rounded),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics_rounded),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_rounded),
                label: 'Itinerary',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            unselectedItemColor:
                isDarkMode ? Colors.grey[400] : Colors.grey[600],
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            showUnselectedLabels: true,
            elevation: 0,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
