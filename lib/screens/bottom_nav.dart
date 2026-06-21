import 'package:dotty/models/category_model.dart';
import 'package:dotty/screens/favorite_screen.dart';
import 'package:dotty/screens/recent_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../api_servie/wallpaper_Api.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  final List<Wallpaper> recentWallpapers;

  const MainScreen({
    super.key,
    required this.recentWallpapers,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;

  late List<Wallpaper> recentWallpapers;

  @override
  void initState() {
    super.initState();
    recentWallpapers = List<Wallpaper>.from(widget.recentWallpapers);
  }

  @override
  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final bg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF7F8FC);

    final accent =
    isDark ? Colors.white : Colors.black;

    final secondary =
    isDark ? Colors.white60 : Colors.black54;

    final pages = [
      const HomeScreen(),
      const CategoriesPage(),
      const SavedScreen(),
      RecentPage(
        recentWallpapers: recentWallpapers,
        onUpdate: (updatedList) {
          setState(() {
            recentWallpapers = updatedList;
          });
        },
      ),
    ];

    return LiquidGlassView(
      backgroundWidget: pages[currentTab],
      child: Scaffold(
        backgroundColor: bg,
        extendBody: true,

        /// BODY
        body: IndexedStack(
          index: currentTab,
          children: pages,
        ),

        /// NAV BAR
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 76.h,
                  child: LiquidGlassLens(
                    style: LiquidGlassStyle(
                      shape: LiquidGlassShape.squircle(
                        cornerRadius: 40.r,
                        borderType: OpticalBorder(
                          borderSaturation: 1.6,
                          ambientIntensity: 1.4,
                        ),
                      ),

                      appearance: LiquidGlassAppearance(
                        color: isDark
                            ? Colors.white.withOpacity(.05)
                            : Colors.white.withOpacity(.14),
                      ),

                      refraction: const LiquidGlassRefraction(
                        distortion: .15,
                        distortionWidth: 32,
                        magnification: 1.03,
                      ),
                    ),

                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          /// HOME
                          _navItem(
                            icon: Hicons.home3LightOutline,
                            label: "Home",
                            selected: currentTab == 0,
                            accent: accent,
                            secondary: secondary,
                            onTap: () {
                              if (currentTab == 0) return;
                              setState(() => currentTab = 0);
                            },
                          ),

                          SizedBox(width: 6.w),

                          /// BROWSE
                          _navItem(
                            icon: Hicons.categoryLightOutline,
                            label: "Browse",
                            selected: currentTab == 1,
                            accent: accent,
                            secondary: secondary,
                            onTap: () {
                              if (currentTab == 1) return;
                              setState(() => currentTab = 1);
                            },
                          ),

                          SizedBox(width: 6.w),

                          /// SAVED
                          _navItem(
                            icon: Hicons.heart3LightOutline,
                            label: "Saved",
                            selected: currentTab == 2,
                            accent: accent,
                            secondary: secondary,
                            onTap: () {
                              if (currentTab == 2) return;
                              setState(() => currentTab = 2);
                            },
                          ),

                          SizedBox(width: 6.w),

                          /// RECENT
                          Stack(
                            clipBehavior: Clip.none,
                            children: [

                              _navItem(
                                icon: Icons.history_rounded,
                                label: "Recent",
                                selected: currentTab == 3,
                                accent: accent,
                                secondary: secondary,
                                onTap: () {
                                  if (currentTab == 3) return;
                                  setState(() => currentTab = 3);
                                },
                              ),

                              Positioned(
                                right: -2,
                                top: -2,
                                child: AnimatedSwitcher(
                                  duration: const Duration(
                                    milliseconds: 500,
                                  ),

                                  transitionBuilder:
                                      (child, animation) {
                                    return ScaleTransition(
                                      scale: CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.elasticOut,
                                      ),
                                      child: child,
                                    );
                                  },

                                  child: recentWallpapers.isNotEmpty
                                      ? Container(
                                    key: ValueKey(
                                      recentWallpapers.length,
                                    ),

                                    padding:
                                    const EdgeInsets.all(5),

                                    decoration:
                                    const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),

                                    child: Text(
                                      recentWallpapers.length
                                          .toString(),

                                      style:
                                      const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  )
                                      : const SizedBox.shrink(),
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
                    .fadeIn(
                  duration: 900.ms,
                )
                    .moveY(
                  begin: 40,
                  end: 0,
                  curve: Curves.easeOutExpo,
                )
                    .scaleXY(
                  begin: .95,
                  end: 1,
                  duration: 900.ms,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool selected,
    required Color accent,
    required Color secondary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutExpo,
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 18.w : 12.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: selected
              ? Colors.white.withOpacity(.08)
              : Colors.transparent,
          boxShadow: selected
              ? [
            BoxShadow(
              blurRadius: 20,
              spreadRadius: 1,
              color: accent.withOpacity(.08),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutBack,
              scale: selected ? 1.12 : 1,
              child: Icon(
                icon,
                size: 24.sp,
                color: selected ? accent : secondary,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutExpo,
              child: selected
                  ? Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    color: accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
