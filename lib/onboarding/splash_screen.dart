import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api_servie/wallpaper_Api.dart';
import '../screens/bottom_nav.dart';
import 'onboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final accent = const Color(0xFF7C4DFF);

  String wallpaper = "";

  @override
  void initState() {
    super.initState();

    loadWallpaper();
  }

  Future<void> loadWallpaper() async {
    try {
      final apiUrl = dotenv.env['API_URL'];

      final response = await http.get(Uri.parse(apiUrl!));

      final data = jsonDecode(response.body);

      List<String> wallpapers = [];

      List<Wallpaper> loadedWallpapers = [];

      data['categories'].forEach((key, value) {
        final items = List<String>.from(value['wallpapers']);

        wallpapers.addAll(items);

        for (var image in items) {
          loadedWallpapers.add(
            Wallpaper(
              id: image.hashCode.toString(),

              image: image,

              title: "${key} Wallpaper",
              subtitle: "Premium wallpaper",

              category: key,

              isViewed: false,

              addedAt: DateTime.now(),
            ),
          );
        }
      });

      wallpapers.shuffle();

      wallpaper = wallpapers.first;
      recentWallpapers = loadedWallpapers;

      setState(() {});

      await openApp();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<Wallpaper> recentWallpapers = [];

  Future<void> openApp() async {
    final prefs = await SharedPreferences.getInstance();

    final seen = prefs.getBool('onboarding_done') ?? false;

    // FIRST INSTALL
    if (!seen) {
      await prefs.setBool('onboarding_done', true);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,

        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1200),

          pageBuilder: (_, __, ___) => const OnboardingScreen(),

          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );

      return;
    }

    // SPLASH AFTER FIRST INSTALL
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,

      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1200),

        pageBuilder: (_, __, ___) =>
            MainScreen(recentWallpapers: recentWallpapers),

        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final text = isDark ? Colors.white : const Color(0xFF121212);

    final secondary = isDark ? Colors.white70 : Colors.black54;

    final glass = isDark
        ? Colors.white.withOpacity(.08)
        : Colors.white.withOpacity(.24);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,

      body: wallpaper.isEmpty
          ? Center(child: CircularProgressIndicator(color: accent))
          : Stack(
              fit: StackFit.expand,

              children: [
                // WALLPAPER
                Hero(
                  tag: wallpaper,

                  child: Image.network(wallpaper, fit: BoxFit.cover)
                      .animate(
                        onPlay: (c) {
                          c.repeat(reverse: true);
                        },
                      )
                      .scale(
                        begin: const Offset(1, 1),

                        end: const Offset(1.08, 1.08),

                        duration: 14.seconds,
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

                              Colors.white.withOpacity(.56),

                              Colors.white.withOpacity(.92),
                            ],
                    ),
                  ),
                ),

                // CINEMATIC BLUR
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),

                  child: Container(color: Colors.transparent),
                ),

                // ACCENT GLOW
                Positioned(
                  top: -120.h,

                  right: -90.w,

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

                // SECOND GLOW
                Positioned(
                  bottom: -140.h,

                  left: -120.w,

                  child:
                      Container(
                            width: 340.w,

                            height: 340.h,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              color: isDark
                                  ? Colors.white.withOpacity(.08)
                                  : accent.withOpacity(.12),
                            ),
                          )
                          .animate(
                            onPlay: (c) {
                              c.repeat(reverse: true);
                            },
                          )
                          .scale(
                            begin: const Offset(1, 1),

                            end: const Offset(1.12, 1.12),

                            duration: 6.seconds,
                          )
                          .blurXY(begin: 120, end: 180),
                ),

                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,

                      vertical: 26.h,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // MINI LOGO
                        Align(
                          alignment: Alignment.centerRight,

                          child: ClipRRect(
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

                                    fontSize: 11.sp,

                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ).animate().fadeIn().moveX(begin: 40, end: 0),
                        ),

                        const Spacer(),

                        // MAIN TITLE
                        Align(
                          alignment: Alignment.centerRight,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,

                            children: [
                              Text(
                                    "DOTTY",

                                    textAlign: TextAlign.right,

                                    style: GoogleFonts.bebasNeue(
                                      color: text,

                                      fontSize: 102.sp,

                                      letterSpacing: 5,

                                      height: .9,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 1000.ms)
                                  .moveY(
                                    begin: 50,

                                    end: 0,

                                    curve: Curves.easeOutExpo,
                                  ),

                              SizedBox(height: 18.h),

                              SizedBox(
                                width: .72.sw,

                                child: Text(
                                  "A cinematic wallpaper experience crafted with immersive visuals and fluid ultra modern aesthetics.",

                                  textAlign: TextAlign.right,

                                  style: GoogleFonts.inter(
                                    color: secondary,

                                    fontSize: 15.sp,

                                    height: 1.9,
                                  ),
                                ).animate().fadeIn(delay: 300.ms),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 60.h),

                        // GLASS BOTTOM CARD
                        ClipRRect(
                              borderRadius: BorderRadius.circular(36.r),

                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 24,

                                  sigmaY: 24,
                                ),

                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 22.w,

                                    vertical: 20.h,
                                  ),

                                  decoration: BoxDecoration(
                                    color: glass,

                                    borderRadius: BorderRadius.circular(36.r),

                                    border: Border.all(
                                      color: Colors.white.withOpacity(.08),
                                    ),
                                  ),

                                  child: Row(
                                    children: [
                                      SizedBox(
                                            width: 24.w,

                                            height: 24.h,

                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.3,

                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                    accent,
                                                  ),
                                            ),
                                          )
                                          .animate(
                                            onPlay: (c) {
                                              c.repeat();
                                            },
                                          )
                                          .rotate(duration: 2.seconds),

                                      SizedBox(width: 18.w),

                                      Expanded(
                                        child: Text(
                                          "Loading immersive experience...",

                                          style: GoogleFonts.inter(
                                            color: text,

                                            fontSize: 13.sp,

                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 600.ms)
                            .moveY(
                              begin: 40,

                              end: 0,

                              curve: Curves.easeOutExpo,
                            ),

                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
