import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trvlus/Screens/Home_Page.dart';
import 'package:trvlus/Screens/ProfilePage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of image paths for the navigation items
  final List<String> _imagePaths = [
    'assets/images/HomeImage.png',
    'assets/images/fly1.png',
    'assets/images/tag.png',
    'assets/images/profile.png',
  ];

  // List of pages corresponding to each navigation item
  final List<Widget> _pages = [
    HomePage(),
    //Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Flights Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Offers Page', style: TextStyle(fontSize: 24))),
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Show the selected page
      bottomNavigationBar: Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_imagePaths.length, (index) {
            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedIndex == index
                        ? Colors.blue
                        : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Image.asset(
                  _imagePaths[index],
                  color: _selectedIndex == index ? Colors.blue : Colors.grey,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
