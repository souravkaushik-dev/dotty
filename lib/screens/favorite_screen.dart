import 'dart:ui';

import 'package:dotty/screens/previewscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/fav_service.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  Future<List<Map<String, dynamic>>> fetchFavorites() {
    return FavoritesService.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accent = const Color(0xFF7C4DFF);

    final bg = isDark ? const Color(0xFF0F1115) : const Color(0xFFF7F8FC);

    final text = isDark ? Colors.white : const Color(0xFF121212);

    final secondary = isDark ? Colors.white60 : Colors.black54;

    final heights = [340.h, 260.h, 390.h, 300.h];

    return Scaffold(
      backgroundColor: bg,

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFavorites(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: accent));
          }

          final favorites = snapshot.data!;

          // EMPTY STATE
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32.r),

                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

                      child: Container(
                        width: 110.w,

                        height: 110.h,

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.05),

                          borderRadius: BorderRadius.circular(32.r),

                          border: Border.all(
                            color: Colors.white.withOpacity(.05),
                          ),
                        ),

                        child: Icon(
                          Icons.favorite_border_rounded,

                          size: 46.sp,

                          color: Colors.white24,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 28.h),

                  Text(
                    "No Favorites Yet",

                    style: GoogleFonts.inter(
                      color: text,

                      fontSize: 28.sp,

                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),

                    child: Text(
                      "Your saved premium wallpaper collection will appear here.",

                      textAlign: TextAlign.center,

                      style: GoogleFonts.inter(
                        color: secondary,

                        fontSize: 14.sp,

                        height: 1.8,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 700.ms).moveY(begin: 40, end: 0),
            );
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),

            slivers: [
              // HERO
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 78.h, 24.w, 10.h),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                            "SAVED",

                            style: GoogleFonts.bebasNeue(
                              color: text,

                              fontSize: 92.sp,

                              height: .9,

                              letterSpacing: 2,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 900.ms)
                          .moveY(begin: 60, end: 0, curve: Curves.easeOutExpo),

                      SizedBox(height: 14.h),

                      Text(
                        "Your curated collection of immersive wallpapers and cinematic visual aesthetics.",

                        style: GoogleFonts.inter(
                          color: secondary,

                          fontSize: 15.sp,

                          height: 1.8,
                        ),
                      ).animate().fadeIn(delay: 200.ms),

                      SizedBox(height: 20.h),

                      Row(
                            children: [
                              _glassChip(
                                icon: Icons.favorite_rounded,

                                text: "Favorites",
                              ),

                              SizedBox(width: 12.w),

                              _glassChip(
                                icon: Icons.auto_awesome_rounded,

                                text: "Premium",
                              ),

                              SizedBox(width: 12.w),

                              _glassChip(
                                icon: Icons.wallpaper_rounded,

                                text: "${favorites.length}",
                              ),
                            ],
                          )
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .moveY(begin: 20, end: 0),
                    ],
                  ),
                ),
              ),

              // TITLE
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 24.h),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        "Collection",

                        style: GoogleFonts.inter(
                          fontSize: 30.sp,

                          fontWeight: FontWeight.w800,

                          color: text,
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,

                          vertical: 9.h,
                        ),

                        decoration: BoxDecoration(
                          color: accent.withOpacity(.12),

                          borderRadius: BorderRadius.circular(22.r),
                        ),

                        child: Text(
                          "${favorites.length}",

                          style: GoogleFonts.inter(
                            color: accent,

                            fontWeight: FontWeight.w700,

                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // GRID
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),

                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,

                  mainAxisSpacing: 18.h,

                  crossAxisSpacing: 18.w,

                  childCount: favorites.length,

                  itemBuilder: (context, index) {
                    final item = favorites[index];

                    final image = item['imageUrl'];

                    final category = item['category'];

                    return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => PreviewScreen(
                                  imageUrl: image,

                                  category: category,
                                ),
                              ),
                            );
                          },

                          child: Hero(
                            tag: image,

                            child: Container(
                              height: heights[index % 4],

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(38.r),

                                image: DecorationImage(
                                  image: NetworkImage(image),

                                  fit: BoxFit.cover,
                                ),
                              ),

                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(38.r),

                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,

                                    end: Alignment.bottomCenter,

                                    colors: [
                                      Colors.transparent,

                                      Colors.black.withOpacity(.75),
                                    ],
                                  ),
                                ),

                                child: Padding(
                                  padding: EdgeInsets.all(18.w),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),

                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 12,

                                            sigmaY: 12,
                                          ),

                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 14.w,

                                              vertical: 8.h,
                                            ),

                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                .08,
                                              ),

                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),

                                            child: Text(
                                              "SAVED",

                                              style: GoogleFonts.inter(
                                                color: Colors.white,

                                                fontSize: 11.sp,

                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(
                          delay: Duration(milliseconds: index * 80),

                          duration: 900.ms,
                        )
                        .moveY(begin: 80, end: 0, curve: Curves.easeOutExpo)
                        .scale(
                          begin: const Offset(.88, .88),

                          end: const Offset(1, 1),

                          duration: 900.ms,

                          curve: Curves.easeOutExpo,
                        )
                        .blurXY(begin: 2, end: 0, duration: 700.ms);
                  },
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 120.h)),
            ],
          );
        },
      ),
    );
  }

  Widget _glassChip({required IconData icon, required String text}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.r),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.06),

            borderRadius: BorderRadius.circular(22.r),

            border: Border.all(color: Colors.white.withOpacity(.05)),
          ),

          child: Row(
            children: [
              Icon(icon, color: Colors.white70, size: 18.sp),

              SizedBox(width: 8.w),

              Text(
                text,

                style: GoogleFonts.inter(
                  color: Colors.white,

                  fontWeight: FontWeight.w600,

                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
