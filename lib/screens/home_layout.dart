import 'package:flutter/material.dart';
import 'package:untitled2/screens/aiCamera/aiCamera.dart';
import 'package:untitled2/screens/discovery_screens/Profile_settings.dart';
import 'package:untitled2/screens/discovery_screens/home_screen.dart';
import 'package:untitled2/screens/maps/ShowMap.dart';

class Cupertinolayout extends StatefulWidget {
  @override
  State<Cupertinolayout> createState() => _CupertinolayoutState();
}

GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');

class _CupertinolayoutState extends State<Cupertinolayout> {
  String _currentPage = "Page1";

  List<String> pageKeys = ["Page1", "Page2", "Page3", "Page4"];

  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Page1": GlobalKey<NavigatorState>(),
    "Page2": GlobalKey<NavigatorState>(),
    "Page3": GlobalKey<NavigatorState>(),
    "Page4": GlobalKey<NavigatorState>(),
  };

  int _selectedIndex = 0;

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentPage]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "Page1") {
            _selectTab("Page1", 0);
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator("Page1"),
          _buildOffstageNavigator("Page2"),
          _buildOffstageNavigator("Page3"),
          _buildOffstageNavigator("Page4"),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          key: globalKey,

          onTap: (int index) {
            _selectTab(pageKeys[index], index);
          },
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.camera_alt,
              ),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(0xe3c8, fontFamily: 'MaterialIcons'),
              ),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(0xeb8e, fontFamily: 'MaterialIcons'),
              ),
              label: 'Profile',
            ),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final String? tabItem;

  const TabNavigator({this.navigatorKey, this.tabItem});

  @override
  Widget build(BuildContext context) {
    late Widget child;
    if (tabItem == "Page1") {
      child = home_screen();
    } else if (tabItem == "Page2") {
      child = AiCamera();
    } else if (tabItem == "Page3") {
      child = Show_Maps();
    } else if (tabItem == "Page4") {
      child = ProfileSettings();
    }

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
