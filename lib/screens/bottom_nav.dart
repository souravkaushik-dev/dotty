import 'package:dotty/screens/recent_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../api_servie/wallpaper_Api.dart';
import '../models/category_model.dart';
import 'favorite_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  final List<Wallpaper> recentWallpapers;

  const MainScreen({
    super.key,
    required this.recentWallpapers,
  });

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;

  late List<Wallpaper> recentWallpapers;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();

    recentWallpapers =
    List<Wallpaper>.from(widget.recentWallpapers);

    pages = [
      const HomeScreen(),
      const CategoriesPage(),
      const SavedScreen(),
      RecentPage(
        recentWallpapers: recentWallpapers,
        onUpdate: (updated) {
          setState(() {
            recentWallpapers = updated;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          IndexedStack(
            index: currentTab,
            children: pages,
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 16.h,
                ),
                child: LiquidGlassBottomNavBar.withImpeller(
                  selectedIndex: currentTab,
                  onChanged: (index) {
                    debugPrint("Tapped: $index");

                    HapticFeedback.selectionClick();

                    setState(() {
                      currentTab = index;
                    });
                  },
                  items: [
                    const LiquidGlassTabBarItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                    ),
                    const LiquidGlassTabBarItem(
                      icon: Icons.grid_view_rounded,
                      label: 'Categories',
                    ),
                    const LiquidGlassTabBarItem(
                      icon: Icons.favorite_rounded,
                      label: 'Saved',
                    ),
                    LiquidGlassTabBarItem(
                      icon: Icons.history_rounded,
                      label: recentWallpapers.isEmpty
                          ? 'Recent'
                          : 'Recent (${recentWallpapers.length})',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

