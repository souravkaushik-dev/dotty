import 'dart:ui';

import 'package:dotty/screens/previewscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api_servie/wallpaper_Api.dart';

class RecentPage extends StatefulWidget {
  final List<Wallpaper> recentWallpapers;
  final Function(List<Wallpaper>) onUpdate;

  const RecentPage({
    super.key,
    required this.recentWallpapers,
    required this.onUpdate,
  });

  @override
  State<RecentPage> createState() =>
      _RecentPageState();
}

class _RecentPageState
    extends State<RecentPage> {
  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final bg =
    isDark
        ? const Color(0xFF0F1115)
        : Colors.white;

    final text =
    isDark ? Colors.white : Colors.black;

    final secondary =
    isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: bg,

      body: CustomScrollView(
        physics:
        const BouncingScrollPhysics(),

        slivers: [
          // HERO
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                24.w,
                78.h,
                24.w,
                20.h,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Text(
                    "RECENT",

                    style:
                    GoogleFonts.bebasNeue(
                      color: text,
                      fontSize: 90.sp,
                      height: .9,
                      letterSpacing: 2,
                    ),
                  )
                      .animate()
                      .fadeIn(
                    duration: 900.ms,
                  )
                      .moveY(
                    begin: 50,
                    end: 0,
                  ),

                  SizedBox(height: 14.h),

                  Text(
                    "Freshly added wallpapers curated for immersive modern setups.",

                    style: GoogleFonts.inter(
                      color: secondary,
                      fontSize: 15.sp,
                      height: 1.8,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  Row(
                    children: [
                      _glassChip(
                        icon:
                        Icons.history_rounded,

                        text:
                        "${widget.recentWallpapers.length}",
                      ),

                      SizedBox(width: 12.w),

                      _glassChip(
                        icon: Icons
                            .auto_awesome_rounded,

                        text: "Latest",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // EMPTY STATE
          if (widget
              .recentWallpapers
              .isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,

              child: Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .center,

                  children: [
                    Icon(
                      Icons
                          .history_toggle_off_rounded,

                      color: secondary,
                      size: 70.sp,
                    ),

                    SizedBox(height: 18.h),

                    Text(
                      "No Recent Wallpapers",

                      style:
                      GoogleFonts.inter(
                        color: text,
                        fontSize: 20.sp,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "Recently viewed wallpapers will appear here.",

                      textAlign:
                      TextAlign.center,

                      style:
                      GoogleFonts.inter(
                        color: secondary,
                        fontSize: 14.sp,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            )

          else
          // GRID
            SliverPadding(
              padding:
              EdgeInsets.symmetric(
                horizontal: 20.w,
              ),

              sliver:
              SliverMasonryGrid.count(
                crossAxisCount: 2,

                mainAxisSpacing: 18.h,
                crossAxisSpacing: 18.w,

                childCount: widget
                    .recentWallpapers
                    .length,

                itemBuilder:
                    (context, index) {
                  final wallpaper =
                  widget
                      .recentWallpapers[
                  index];

                  final heights = [
                    340.h,
                    260.h,
                    390.h,
                    300.h,
                  ];

                  return GestureDetector(
                    onTap: () {
                      final updatedList =
                      List<Wallpaper>.from(
                        widget.recentWallpapers,
                      );

                      updatedList.removeAt(index);

                      setState(() {
                        widget.recentWallpapers.clear();
                        widget.recentWallpapers.addAll(
                          updatedList,
                        );
                      });

                      widget.onUpdate(updatedList);

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => PreviewScreen(
                            imageUrl: wallpaper.image,
                            category: wallpaper.category,
                          ),
                        ),
                      );
                    },

                    child: Container(
                      height:
                      heights[index %
                          4],

                      decoration:
                      BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(
                          42.r,
                        ),

                        image:
                        DecorationImage(
                          image:
                          NetworkImage(
                            wallpaper
                                .image,
                          ),

                          fit:
                          BoxFit.cover,
                        ),
                      ),

                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                            42.r,
                          ),

                          gradient:
                          LinearGradient(
                            begin: Alignment
                                .topCenter,

                            end: Alignment
                                .bottomCenter,

                            colors: [
                              Colors
                                  .transparent,

                              Colors.black
                                  .withOpacity(
                                .92,
                              ),
                            ],
                          ),
                        ),

                        child: Padding(
                          padding:
                          EdgeInsets.all(
                            22.w,
                          ),

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [
                              // CATEGORY CHIP
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(
                                  22.r,
                                ),

                                child:
                                BackdropFilter(
                                  filter:
                                  ImageFilter.blur(
                                    sigmaX:
                                    12,
                                    sigmaY:
                                    12,
                                  ),

                                  child:
                                  Container(
                                    padding:
                                    EdgeInsets.symmetric(
                                      horizontal:
                                      14.w,

                                      vertical:
                                      8.h,
                                    ),

                                    decoration:
                                    BoxDecoration(
                                      color: Colors
                                          .white
                                          .withOpacity(
                                        .08,
                                      ),

                                      borderRadius:
                                      BorderRadius.circular(
                                        22.r,
                                      ),

                                      border:
                                      Border.all(
                                        color: Colors
                                            .white
                                            .withOpacity(
                                          .05,
                                        ),
                                      ),
                                    ),

                                    child:
                                    Text(
                                      wallpaper
                                          .category,

                                      style:
                                      GoogleFonts.inter(
                                        color:
                                        Colors.white,

                                        fontSize:
                                        11.sp,

                                        fontWeight:
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // WALLPAPER NAME
                              Text(
                                wallpaper.title.isNotEmpty
                                    ? wallpaper.title.toUpperCase()
                                    : getWallpaperName(
                                  wallpaper.image,
                                ),

                                maxLines: 2,

                                overflow:
                                TextOverflow
                                    .ellipsis,

                                style:
                                GoogleFonts
                                    .bebasNeue(
                                  color: Colors
                                      .white,

                                  fontSize:
                                  46.sp,

                                  height: .9,

                                  letterSpacing:
                                  2,
                                ),
                              ),

                              SizedBox(
                                height: 8.h,
                              ),

                              // SUBTITLE
                              Text(
                                wallpaper
                                    .subtitle,

                                maxLines: 2,

                                overflow:
                                TextOverflow
                                    .ellipsis,

                                style:
                                GoogleFonts
                                    .inter(
                                  color: Colors
                                      .white70,

                                  fontSize:
                                  12.sp,

                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                    delay: Duration(
                      milliseconds:
                      index * 100,
                    ),

                    duration: 900.ms,
                  )
                      .moveY(
                    begin: 80,
                    end: 0,
                    curve:
                    Curves.easeOutExpo,
                  )
                      .scale(
                    begin:
                    const Offset(
                      .9,
                      .9,
                    ),

                    end:
                    const Offset(
                      1,
                      1,
                    ),

                    duration:
                    900.ms,
                  );
                },
              ),
            ),

          SliverToBoxAdapter(
            child:
            SizedBox(height: 120.h),
          ),
        ],
      ),
    );
  }

  String getWallpaperName(
      String imageUrl,
      ) {
    final fileName =
        imageUrl.split('/').last;

    final cleanName =
    fileName
        .split('.')
        .first
        .replaceAll(
      RegExp(r'\d+x\d+'),
      '',
    )
        .replaceAll(
      RegExp(r'\d+'),
      '',
    )
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .trim();

    return cleanName.toUpperCase();
  }

  Widget _glassChip({
    required IconData icon,
    required String text,
  }) {
    return ClipRRect(
      borderRadius:
      BorderRadius.circular(22.r),

      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 12,
          sigmaY: 12,
        ),

        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 10.h,
          ),

          decoration: BoxDecoration(
            color:
            Colors.white.withOpacity(
              .06,
            ),

            borderRadius:
            BorderRadius.circular(
              22.r,
            ),

            border: Border.all(
              color:
              Colors.white.withOpacity(
                .05,
              ),
            ),
          ),

          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white70,
                size: 18.sp,
              ),

              SizedBox(width: 8.w),

              Text(
                text,

                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight:
                  FontWeight.w600,
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