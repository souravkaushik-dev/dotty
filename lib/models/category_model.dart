import 'dart:convert';
import 'dart:ui';

import 'package:dotty/screens/category_spage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  Future<Map<String, dynamic>> fetchData() async {
    final apiUrl = dotenv.env['API_URL'];

    final res = await http.get(Uri.parse(apiUrl!));

    return jsonDecode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

final accent = isDark ? Colors.white : Colors.black;

    final bg = isDark ? const Color(0xFF0F1115) : const Color(0xFFF7F8FC);

    final text = isDark ? Colors.white : const Color(0xFF121212);

    final secondary = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: bg,

      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: accent));
          }

          final data = snapshot.data!;

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
                            "DISCOVER",

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
                        "Curated wallpaper collections crafted with cinematic visuals and immersive modern aesthetics.",

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
                                icon: Icons.auto_awesome_rounded,

                                text: "Premium",
                              ),

                              SizedBox(width: 12.w),

                              _glassChip(icon: Icons.bolt_rounded, text: "4K"),

                              SizedBox(width: 12.w),

                              _glassChip(
                                icon: Icons.wallpaper_rounded,

                                text: "${data['categories'].length}",
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
                        "Collections",

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
                          "${data['categories'].length}",

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

                  childCount: data['categories'].length,

                  itemBuilder: (context, index) {
                    final categoryName = data['categories'].keys
                        .toList()[index];

                    final category = data['categories'][categoryName];

                    final thumbnail = category['thumbnail'];

                    final wallpapers = category['wallpapers'];

                    final heights = [340.h, 260.h, 390.h, 300.h];

                    return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,

                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 800,
                                ),

                                pageBuilder: (_, __, ___) => CategoryScreen(
                                  title: categoryName,

                                  wallpapers: List<String>.from(wallpapers),
                                ),

                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,

                                        child: SlideTransition(
                                          position:
                                              Tween<Offset>(
                                                begin: const Offset(0, .06),

                                                end: Offset.zero,
                                              ).animate(
                                                CurvedAnimation(
                                                  parent: animation,

                                                  curve: Curves.easeOutExpo,
                                                ),
                                              ),

                                          child: child,
                                        ),
                                      );
                                    },
                              ),
                            );
                          },

                          child: Hero(
                            tag: categoryName,

                            child: Container(
                              height: heights[index % 4],

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(42.r),

                                image: DecorationImage(
                                  image: NetworkImage(thumbnail),

                                  fit: BoxFit.cover,
                                ),
                              ),

                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(42.r),

                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,

                                    end: Alignment.bottomCenter,

                                    colors: [
                                      Colors.transparent,

                                      Colors.black.withOpacity(.92),
                                    ],
                                  ),
                                ),

                                child: Padding(
                                  padding: EdgeInsets.all(22.w),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      // GLASS CHIP
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          22.r,
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
                                                  BorderRadius.circular(22.r),

                                              border: Border.all(
                                                color: Colors.white.withOpacity(
                                                  .05,
                                                ),
                                              ),
                                            ),

                                            child: Text(
                                              "${wallpapers.length} Wallpapers",

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

                                      // TITLE
                                      Text(
                                        categoryName.toUpperCase(),

                                        maxLines: 2,

                                        overflow: TextOverflow.ellipsis,

                                        style: GoogleFonts.bebasNeue(
                                          color: Colors.white,

                                          fontSize: 58.sp,

                                          height: .9,

                                          letterSpacing: 2,
                                        ),
                                      ),

                                      SizedBox(height: 10.h),

                                      // SUBTITLE
                                      Text(
                                        "Premium curated visuals for modern minimal setups.",

                                        maxLines: 2,

                                        overflow: TextOverflow.ellipsis,

                                        style: GoogleFonts.inter(
                                          color: Colors.white70,

                                          fontSize: 12.sp,

                                          height: 1.7,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(
                          delay: Duration(milliseconds: index * 120),

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
