import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../api_servie/wallpaper_Api.dart';
import '../screens/bottom_nav.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();

  int currentPage = 0;

  List<Wallpaper> recentWallpapers = [];

  final Color accent = Colors.black;

  List<Map<String, dynamic>> pages = [];

  Future<void> fetchWallpapers() async {
    try {
      final apiUrl = dotenv.env['API_URL'];

      final response = await http.get(Uri.parse(apiUrl!));

      final data = jsonDecode(response.body);

      List<String> images = [];

      List<Wallpaper> loadedWallpapers = [];

      data['categories'].forEach((key, value) {
        final wallpapers = List<String>.from(value['wallpapers']);

        images.addAll(wallpapers.take(1));

        for (var image in wallpapers) {
          loadedWallpapers.add(
            Wallpaper(
              id: image.hashCode.toString(),

              image: image,

              title: getWallpaperName(image),

              subtitle: "Premium wallpaper",

              category: key,

              isViewed: false,

              addedAt: DateTime.now(),
            ),
          );
        }
      });

      images.shuffle();

      pages = [

        {
          "title": "Immersive\nWallpapers",

          "subtitle":
              "Discover cinematic ultra premium wallpapers crafted for modern minimal aesthetics.",

          "image": images[0],
        },

        {
          "title": "Curated\nCollections",

          "subtitle":
              "Explore futuristic AMOLED, abstract and luxury visual experiences.",

          "image": images[1],
        },

        {
          "title": "Fluid\nExperience",

          "subtitle":
              "Minimal interactions. Smooth animations. Pure modern wallpaper experience.",

          "image": images[2],
        },
      ];

      recentWallpapers = loadedWallpapers;

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String getWallpaperName(String imageUrl) {
    final fileName =
        imageUrl.split('/').last;

    final cleanName =
    fileName
        .split('.')
        .first
        .replaceAll(RegExp(r'\d+x\d+'), '')
        .replaceAll(RegExp(r'\d+'), '')
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .trim();

    return cleanName.toUpperCase();
  }

  @override
  void initState() {
    super.initState();

    fetchWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final text = isDark ? Colors.white : const Color(0xFF121212);

    final secondary = isDark ? Colors.white70 : Colors.black54;

    final glass = isDark
        ? Colors.white.withOpacity(.06)
        : Colors.white.withOpacity(.20);

    if (pages.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,

        body: Center(child: CircularProgressIndicator(color: accent)),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,

      body: PageView.builder(
        controller: controller,

        itemCount: pages.length,

        physics: const BouncingScrollPhysics(),

        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },

        itemBuilder: (context, index) {
          final item = pages[index];

          return Stack(
            fit: StackFit.expand,

            children: [
              // WALLPAPER
              Hero(
                tag: item['image'],

                child: Image.network(item['image'], fit: BoxFit.cover)
                    .animate(
                      onPlay: (c) {
                        c.repeat(reverse: true);
                      },
                    )
                    .scale(
                      begin: const Offset(1, 1),

                      end: const Offset(1.08, 1.08),

                      duration: 12.seconds,
                    ),
              ),

              // OVERLAY
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,

                    end: Alignment.bottomCenter,

                    colors: isDark
                        ? [
                            Colors.black.withOpacity(.10),

                            Colors.black.withOpacity(.58),

                            Colors.black.withOpacity(.96),
                          ]
                        : [
                            Colors.white.withOpacity(.10),

                            Colors.white.withOpacity(.54),

                            Colors.white.withOpacity(.92),
                          ],
                  ),
                ),
              ),

              // SOFT BLUR
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),

                child: Container(color: Colors.transparent),
              ),

              // GLOW
              Positioned(
                top: -120.h,

                right: -100.w,

                child:
                    Container(
                          width: 360.w,

                          height: 360.h,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            color: accent.withOpacity(.22),
                          ),
                        )
                        .animate(
                          onPlay: (c) {
                            c.repeat(reverse: true);
                          },
                        )
                        .scale(
                          begin: const Offset(1, 1),

                          end: const Offset(1.18, 1.18),

                          duration: 5.seconds,
                        )
                        .blurXY(begin: 100, end: 170),
              ),

              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,

                    vertical: 24.h,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // TOP BAR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28.r),

                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 18.w,

                                  vertical: 10.h,
                                ),

                                decoration: BoxDecoration(
                                  color: glass,

                                  borderRadius: BorderRadius.circular(28.r),

                                  border: Border.all(
                                    color: Colors.white.withOpacity(.08),
                                  ),
                                ),

                                child: Text(
                                  "DOTTY",

                                  style: GoogleFonts.inter(
                                    color: text,

                                    fontWeight: FontWeight.w700,

                                    letterSpacing: 2,

                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => MainScreen(
                                    recentWallpapers: recentWallpapers,
                                  )
                                ),
                              );
                            },

                            child: Text(
                              "Skip",

                              style: GoogleFonts.inter(
                                color: secondary,

                                fontWeight: FontWeight.w600,

                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // TITLE
                      Text(
                            item['title'],

                            style: GoogleFonts.inter(
                              color: text,

                              fontSize: 56.sp,

                              height: .92,

                              fontWeight: FontWeight.w800,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 700.ms)
                          .moveY(begin: 40, end: 0, curve: Curves.easeOutExpo),

                      SizedBox(height: 24.h),

                      // SUBTITLE
                      SizedBox(
                        width: .84.sw,

                        child: Text(
                          item['subtitle'],

                          style: GoogleFonts.inter(
                            color: secondary,

                            fontSize: 15.sp,

                            height: 1.9,
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                      ),

                      SizedBox(height: 44.h),

                      // GLASS BOTTOM
                      ClipRRect(
                        borderRadius: BorderRadius.circular(38.r),

                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),

                          child: Container(
                            padding: EdgeInsets.all(20.w),

                            decoration: BoxDecoration(
                              color: glass,

                              borderRadius: BorderRadius.circular(38.r),

                              border: Border.all(
                                color: Colors.white.withOpacity(.08),
                              ),
                            ),

                            child: Row(
                              children: [
                                // INDICATORS
                                Row(
                                  children: List.generate(pages.length, (i) {
                                    final active = currentPage == i;

                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 450,
                                      ),

                                      margin: EdgeInsets.only(right: 10.w),

                                      width: active ? 42.w : 10.w,

                                      height: 10.h,

                                      decoration: BoxDecoration(
                                        color: active ? accent : Colors.white24,

                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                      ),
                                    );
                                  }),
                                ),

                                const Spacer(),

                                // BUTTON
                                GestureDetector(
                                  onTap: () {
                                    if (currentPage == pages.length - 1) {
                                      Navigator.pushReplacement(
                                        context,

                                        MaterialPageRoute(
                                          builder: (_) => MainScreen(
                                            recentWallpapers: recentWallpapers,
                                          )
                                        ),
                                      );
                                    } else {
                                      controller.nextPage(
                                        duration: const Duration(
                                          milliseconds: 700,
                                        ),

                                        curve: Curves.easeOutExpo,
                                      );
                                    }
                                  },

                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),

                                    width: 74.w,

                                    height: 74.h,

                                    decoration: BoxDecoration(
                                      color: accent,

                                      borderRadius: BorderRadius.circular(30.r),
                                    ),

                                    child: Icon(
                                      currentPage == pages.length - 1
                                          ? Icons.check_rounded
                                          : Icons.arrow_forward_rounded,

                                      color: Colors.white,

                                      size: 28.sp,
                                    ),
                                  ),
                                ).animate().scale(
                                  duration: 700.ms,

                                  curve: Curves.easeOutExpo,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
