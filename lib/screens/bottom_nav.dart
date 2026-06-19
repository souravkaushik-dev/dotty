import 'dart:ui';

import 'package:dotty/models/category_model.dart';
import 'package:dotty/screens/favorite_screen.dart';
import 'package:dotty/screens/recent_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api_servie/wallpaper_Api.dart';
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

  final Color accent = Colors.black;

  late List<Wallpaper> recentWallpapers;

  @override
  void initState() {
    super.initState();

    recentWallpapers =
    List<Wallpaper>.from(
      widget.recentWallpapers,
    );
  }


  int get recentCount {
    if (recentWallpapers.isEmpty) {
      return 0;
    }

    return recentWallpapers.length >= 20
        ? recentWallpapers.length
        : recentWallpapers.length;
  }


  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final bg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF7F8FC);

    final secondary =
    isDark ? Colors.white60 : Colors.black54;

    final List<Widget> pages = [
      const HomeScreen(),

      const CategoriesPage(),

      const SavedScreen(),

      RecentPage(
        recentWallpapers:
        recentWallpapers,

        onUpdate: (updatedList) {
          setState(() {
            recentWallpapers = updatedList;
          });
        },
      ),
    ];

    return Scaffold(
      backgroundColor: bg,

      extendBody: true,

      body: AnimatedSwitcher(
        duration:
        const Duration(milliseconds: 700),

        switchInCurve: Curves.easeOutExpo,

        switchOutCurve: Curves.easeOutExpo,

        transitionBuilder:
            (child, animation) {
          return FadeTransition(
            opacity: animation,

            child: SlideTransition(
              position:
              Tween<Offset>(
                begin: const Offset(
                  0,
                  .03,
                ),

                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,

                  curve:
                  Curves.easeOutExpo,
                ),
              ),

              child: child,
            ),
          );
        },

        child: KeyedSubtree(
          key: ValueKey(currentTab),

          child: pages[currentTab],
        ),
      ),

      // FLOATING NAVBAR
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding:
          EdgeInsets.only(bottom: 14.h),

          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(
                  40.r,
                ),

                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20,
                    sigmaY: 20,
                  ),

                  child: Container(
                    height: 76.h,

                    padding:
                    EdgeInsets.symmetric(
                      horizontal: 12.w,

                      vertical: 10.h,
                    ),

                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white
                          .withOpacity(
                        .03,
                      )
                          : Colors.white
                          .withOpacity(
                        .10,
                      ),

                      borderRadius:
                      BorderRadius.circular(
                        40.r,
                      ),

                      border: Border.all(
                        color: Colors.white
                            .withOpacity(
                          .05,
                        ),

                        width: .8,
                      ),
                    ),

                    child: Row(
                      mainAxisSize:
                      MainAxisSize.min,

                      children: [
                        _navItem(
                          icon:
                          Hicons
                              .home3LightOutline,

                          label: "Home",

                          selected:
                          currentTab ==
                              0,

                          onTap: () {
                            setState(() {
                              currentTab = 0;
                            });
                          },

                          secondary:
                          secondary,
                        ),

                        SizedBox(
                            width: 6.w),

                        _navItem(
                          icon:
                          Hicons
                              .categoryLightOutline,

                          label: "Browse",

                          selected:
                          currentTab ==
                              1,

                          onTap: () {
                            setState(() {
                              currentTab = 1;
                            });
                          },

                          secondary:
                          secondary,
                        ),

                        SizedBox(
                            width: 6.w),

                        _navItem(
                          icon:
                          Hicons
                              .heart3LightOutline,

                          label: "Saved",

                          selected:
                          currentTab ==
                              2,

                          onTap: () {
                            setState(() {
                              currentTab = 2;
                            });
                          },

                          secondary:
                          secondary,
                        ),

                        SizedBox(
                            width: 6.w),

                        // RECENT TAB
                        Stack(
                          children: [
                            _navItem(
                              icon:
                              Icons
                                  .history_rounded,

                              label:
                              "Recent",

                              selected:
                              currentTab ==
                                  3,

                              onTap: () {
                                setState(
                                      () {
                                    currentTab =
                                    3;
                                  },
                                );
                              },

                              secondary:
                              secondary,
                            ),

                            if (recentWallpapers.isNotEmpty)
                              Positioned(
                                right: 6,
                                top: 4,

                                child:
                                Container(
                                  padding:
                                  const EdgeInsets.all(
                                    5,
                                  ),

                                  decoration:
                                  const BoxDecoration(
                                    color:
                                    Colors.red,

                                    shape: BoxShape
                                        .circle,
                                  ),

                                  child:
                                  Text(
                                    recentWallpapers.length.toString(),
                                    style:
                                    const TextStyle(
                                      color:
                                      Colors.white,

                                      fontSize:
                                      10,

                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 700.ms)
                  .moveY(
                begin: 30,
                end: 0,
                curve:
                Curves.easeOutExpo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required Color secondary,
  }) {
    return GestureDetector(
      onTap: onTap,

      behavior:
      HitTestBehavior.translucent,

      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 450),

        curve: Curves.easeOutExpo,

        padding: EdgeInsets.symmetric(
          horizontal:
          selected ? 18.w : 12.w,

          vertical: 10.h,
        ),

        decoration: BoxDecoration(
          color: selected
              ? accent.withOpacity(.12)
              : Colors.transparent,

          borderRadius:
          BorderRadius.circular(24.r),
        ),

        child: Row(
          children: [
            AnimatedScale(
              duration:
              const Duration(milliseconds: 350),

              curve: Curves.easeOutExpo,

              scale: selected ? 1.08 : 1,

              child: Icon(
                icon,

                color:
                selected
                    ? accent
                    : secondary,

                size: 24.sp,
              ),
            ),

            AnimatedSize(
              duration:
              const Duration(milliseconds: 350),

              curve: Curves.easeOutExpo,

              child: selected
                  ? Row(
                children: [
                  SizedBox(
                      width: 10.w),

                  Text(
                    label,

                    style:
                    GoogleFonts.inter(
                      color: accent,

                      fontWeight:
                      FontWeight
                          .w600,

                      fontSize: 13.sp,

                      letterSpacing:
                      -.2,
                    ),
                  ),
                ],
              )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}