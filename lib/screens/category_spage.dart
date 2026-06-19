import 'dart:ui';

import 'package:dotty/screens/previewscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatelessWidget {
  final String title;

  final List<String> wallpapers;

  const CategoryScreen({
    super.key,
    required this.title,
    required this.wallpapers,
  });

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

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),

        slivers: [
          // HERO APPBAR
          SliverAppBar(
            expandedHeight: 420.h,

            pinned: true,

            stretch: true,

            elevation: 0,

            backgroundColor: bg,

            leading: Padding(
              padding: EdgeInsets.all(12.w),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(22.r),

                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.06),

                      borderRadius: BorderRadius.circular(22.r),

                      border: Border.all(color: Colors.white.withOpacity(.05)),
                    ),

                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,

                        color: text,

                        size: 20.sp,
                      ),

                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ),

            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,

                StretchMode.blurBackground,
              ],

              background: Stack(
                fit: StackFit.expand,

                children: [
                  // HERO IMAGE
                  Hero(
                    tag: title,

                    child: wallpapers.isNotEmpty
                        ? Image.network(wallpapers.first, fit: BoxFit.cover)
                        : Container(
                            color: Colors.black,

                            child: Center(
                              child: Icon(
                                Icons.wallpaper_rounded,

                                size: 80.sp,

                                color: Colors.white24,
                              ),
                            ),
                          ),
                  ),

                  // OVERLAY
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,

                        end: Alignment.bottomCenter,

                        colors: [
                          Colors.black.withOpacity(.1),

                          Colors.black.withOpacity(.92),
                        ],
                      ),
                    ),
                  ),

                  // CONTENT
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 120.h, 24.w, 40.h),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      mainAxisAlignment: MainAxisAlignment.end,

                      children: [
                        // CHIP
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),

                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,

                                vertical: 9.h,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.08),

                                borderRadius: BorderRadius.circular(24.r),

                                border: Border.all(
                                  color: Colors.white.withOpacity(.05),
                                ),
                              ),

                              child: Text(
                                "COLLECTION",

                                style: GoogleFonts.inter(
                                  color: Colors.white,

                                  fontWeight: FontWeight.w700,

                                  letterSpacing: 1.2,

                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn().moveY(begin: 20, end: 0),

                        SizedBox(height: 22.h),

                        // TITLE
                        Text(
                              title.toUpperCase(),

                              style: GoogleFonts.bebasNeue(
                                color: Colors.white,

                                fontSize: 74.sp,

                                height: .9,

                                letterSpacing: 2,
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 100.ms)
                            .moveY(
                              begin: 40,
                              end: 0,

                              curve: Curves.easeOutExpo,
                            ),

                        SizedBox(height: 18.h),

                        // DESCRIPTION
                        Text(
                          wallpapers.isNotEmpty
                              ? "${wallpapers.length} immersive wallpapers crafted with cinematic visuals and premium minimal aesthetics."
                              : "No wallpapers available right now.",

                          style: GoogleFonts.inter(
                            color: Colors.white70,

                            fontSize: 14.sp,

                            height: 1.8,
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SECTION TITLE
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 30.h, 24.w, 22.h),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Wallpapers",

                    style: GoogleFonts.inter(
                      fontSize: 28.sp,

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
                      "${wallpapers.length}",

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

          // EMPTY STATE
          if (wallpapers.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.wallpaper_rounded,

                      size: 80.sp,

                      color: Colors.white24,
                    ),

                    SizedBox(height: 22.h),

                    Text(
                      "No Wallpapers Yet",

                      style: GoogleFonts.inter(
                        color: text,

                        fontSize: 24.sp,

                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    Text(
                      "New wallpapers will appear here soon.",

                      style: GoogleFonts.inter(
                        color: secondary,

                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            )
          // GRID
          else
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),

              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,

                mainAxisSpacing: 18.h,

                crossAxisSpacing: 18.w,

                childCount: wallpapers.length,

                itemBuilder: (context, index) {
                  final image = wallpapers[index];

                  return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,

                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 700,
                              ),

                              pageBuilder: (_, __, ___) => PreviewScreen(
                                imageUrl: image,

                                category: title,
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

                                      child: ScaleTransition(
                                        scale: Tween<double>(begin: .94, end: 1)
                                            .animate(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),

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

                                            borderRadius: BorderRadius.circular(
                                              20.r,
                                            ),
                                          ),

                                          child: Text(
                                            "4K",

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
      ),
    );
  }
}
