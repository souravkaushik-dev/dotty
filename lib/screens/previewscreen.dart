import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';

import '../models/fav_service.dart';

class PreviewScreen extends StatefulWidget {
  final String imageUrl;

  final String category;

  const PreviewScreen({
    super.key,
    required this.imageUrl,
    required this.category,
  });

  @override
  State<PreviewScreen> createState() =>
      _PreviewScreenState();
}
class _PreviewScreenState
    extends State<PreviewScreen> {

  final ValueNotifier<bool> isDownloading =
  ValueNotifier(false);

  final ValueNotifier<bool> isFav =
  ValueNotifier(false);

  bool isSettingWallpaper = false;

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF7C4DFF);

    FavoritesService.isFavorite(widget.imageUrl).then((value) {
      isFav.value = value;
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

        statusBarIconBrightness: Brightness.light,

        systemNavigationBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          // WALLPAPER
          Positioned.fill(
            child: Hero(
              tag: widget.imageUrl,

              child: Image.network(widget.imageUrl, fit: BoxFit.cover),
            ),
          ),

          // DEPTH OVERLAY
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,

                  end: Alignment.bottomCenter,

                  colors: [
                    Colors.black.withOpacity(.18),

                    Colors.transparent,

                    Colors.black.withOpacity(.92),
                  ],
                ),
              ),
            ),
          ),

          // GLOW
          Positioned(
            bottom: -120.h,

            left: -40.w,

            child:
                Container(
                      width: 280.w,

                      height: 280.h,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: accent.withOpacity(.18),
                      ),
                    )
                    .animate(
                      onPlay: (controller) {
                        controller.repeat(reverse: true);
                      },
                    )
                    .scale(
                      duration: 5.seconds,

                      begin: const Offset(1, 1),

                      end: const Offset(1.15, 1.15),
                    )
                    .blurXY(begin: 80, end: 120),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),

              child: Column(
                children: [
                  // TOP BAR
                  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          _glassButton(
                            icon: Hicons.left2LightOutline,

                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),

                          Row(
                            children: [
                              ValueListenableBuilder(
                                valueListenable: isFav,

                                builder: (context, value, child) {
                                  return _glassButton(
                                        icon: value
                                            ? Hicons.heart3Bold
                                            : Hicons.heart3LightOutline,

                                        iconColor: value
                                            ? Colors.redAccent
                                            : Colors.white,

                                        onTap: () async {
                                          await FavoritesService.toggleFavorite(
                                            imageUrl: widget.imageUrl,
                                            category: widget.category,
                                          );

                                          isFav.value = !value;
                                        },
                                      )
                                      .animate(target: value ? 1 : 0)
                                      .scale(
                                        begin: const Offset(.8, .8),
                                        end: const Offset(1.15, 1.15),
                                        duration: 300.ms,
                                      );
                                },
                              ),

                              SizedBox(width: 12.w),
                            ],
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(duration: 700.ms)
                      .moveY(begin: -30, end: 0, curve: Curves.easeOutExpo),

                  const Spacer(),

                  // BOTTOM PANEL
                  ClipRRect(
                        borderRadius: BorderRadius.circular(42.r),

                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),

                          child: Container(
                            padding: EdgeInsets.all(28.w),

                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.06),

                              borderRadius: BorderRadius.circular(42.r),

                              border: Border.all(
                                color: Colors.white.withOpacity(.06),
                              ),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                // CATEGORY CHIP
                                ClipRRect(
                                      borderRadius: BorderRadius.circular(24.r),

                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 12,

                                          sigmaY: 12,
                                        ),

                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,

                                            vertical: 9.h,
                                          ),

                                          decoration: BoxDecoration(
                                            color: accent,

                                            borderRadius: BorderRadius.circular(
                                              24.r,
                                            ),
                                          ),

                                          child: Text(
                                            widget.category.toUpperCase(),

                                            style: GoogleFonts.inter(
                                              color: Colors.white,

                                              fontWeight: FontWeight.w700,

                                              letterSpacing: 1.2,

                                              fontSize: 11.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(delay: 200.ms)
                                    .moveX(begin: -20, end: 0),

                                SizedBox(height: 24.h),

                                // TITLE
                                Text(
                                  getWallpaperName(widget.imageUrl),

                                      style: GoogleFonts.inter(
                                        color: Colors.white,

                                        fontSize: 25.sp,

                                        fontWeight: FontWeight.w800,

                                        height: .92,
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(delay: 350.ms)
                                    .moveY(
                                      begin: 30,

                                      end: 0,

                                      curve: Curves.easeOutExpo,
                                    ),

                                SizedBox(height: 16.h),

                                // SUBTITLE
                                Text(
                                  "Immersive premium wallpapers crafted with cinematic visuals and ultra minimal modern aesthetics.",

                                  style: GoogleFonts.inter(
                                    color: Colors.white70,

                                    fontSize: 14.sp,

                                    height: 1.8,
                                  ),
                                ).animate().fadeIn(delay: 500.ms),

                                SizedBox(height: 26.h),

                                // INFO CHIPS
                                Wrap(
                                      spacing: 12.w,

                                      runSpacing: 12.h,

                                      children: [
                                        _infoChip(
                                          icon: Icons.hd_rounded,

                                            text: getResolution(widget.imageUrl),
                                        ),

                                        _infoChip(
                                          icon: Icons.bolt_rounded,

                                          text: "Ultra",
                                        ),

                                        _infoChip(
                                          icon: Hicons.imageLightOutline,

                                          text: "AMOLED",
                                        ),
                                      ],
                                    )
                                    .animate()
                                    .fadeIn(delay: 650.ms)
                                    .moveY(begin: 20, end: 0),

                                SizedBox(height: 34.h),

                                // BUTTONS
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,

                                            backgroundColor: Colors.transparent,

                                            barrierColor: Colors.black54,

                                            isScrollControlled: true,

                                            builder: (_) {
                                              return Padding(
                                                    padding: EdgeInsets.all(
                                                      18.w,
                                                    ),

                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            38.r,
                                                          ),

                                                      child: BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                              sigmaX: 24,
                                                              sigmaY: 24,
                                                            ),

                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                28.w,
                                                              ),

                                                          decoration: BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  .08,
                                                                ),

                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  38.r,
                                                                ),

                                                            border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                    .06,
                                                                  ),
                                                            ),
                                                          ),

                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,

                                                            children: [
                                                              Container(
                                                                width: 60.w,

                                                                height: 5.h,

                                                                decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white24,

                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        20.r,
                                                                      ),
                                                                ),
                                                              ),

                                                              SizedBox(
                                                                height: 28.h,
                                                              ),

                                                              Text(
                                                                "Set Wallpaper",

                                                                style: GoogleFonts.inter(
                                                                  color: Colors
                                                                      .white,

                                                                  fontSize:
                                                                      26.sp,

                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                              ),

                                                              SizedBox(
                                                                height: 10.h,
                                                              ),

                                                              Text(
                                                                "Choose where you want to apply this wallpaper.",

                                                                textAlign:
                                                                    TextAlign
                                                                        .center,

                                                                style: GoogleFonts.inter(
                                                                  color: Colors
                                                                      .white60,

                                                                  fontSize:
                                                                      14.sp,

                                                                  height: 1.8,
                                                                ),
                                                              ),

                                                              SizedBox(
                                                                height: 34.h,
                                                              ),

                                                              _wallpaperOption(
                                                                icon: Hicons
                                                                    .home2LightOutline,

                                                                title:
                                                                    "Home Screen",

                                                                subtitle:
                                                                    "Apply to your home screen only",

                                                                accent: accent,

                                                                onTap: () async {
                                                                  Navigator.pop(
                                                                    context,
                                                                  );

                                                                  await _setWallpaper(
                                                                    location:
                                                                        WallpaperManagerPlus
                                                                            .homeScreen,
                                                                  );

                                                                  _showDone(
                                                                    context,
                                                                    "Wallpaper applied to Home Screen",
                                                                  );
                                                                },
                                                              ),

                                                              SizedBox(
                                                                height: 16.h,
                                                              ),

                                                              _wallpaperOption(
                                                                icon: Hicons
                                                                    .lock3LightOutline,

                                                                title:
                                                                    "Lock Screen",

                                                                subtitle:
                                                                    "Apply to your lock screen only",

                                                                accent: accent,

                                                                onTap: () async {
                                                                  Navigator.pop(
                                                                    context,
                                                                  );

                                                                  await _setWallpaper(
                                                                    location:
                                                                        WallpaperManagerPlus
                                                                            .lockScreen,
                                                                  );

                                                                  _showDone(
                                                                    context,
                                                                    "Wallpaper applied to Lock Screen",
                                                                  );
                                                                },
                                                              ),

                                                              SizedBox(
                                                                height: 16.h,
                                                              ),

                                                              _wallpaperOption(
                                                                icon: Hicons
                                                                    .categoryLightOutline,

                                                                title:
                                                                    "Both Screens",

                                                                subtitle:
                                                                    "Apply everywhere instantly",

                                                                accent: accent,

                                                                onTap: () async {
                                                                  Navigator.pop(
                                                                    context,
                                                                  );

                                                                  await _setWallpaper(
                                                                    location:
                                                                        WallpaperManagerPlus
                                                                            .bothScreens,
                                                                  );

                                                                  _showDone(
                                                                    context,
                                                                    "Wallpaper applied successfully",
                                                                  );
                                                                },
                                                              ),

                                                              SizedBox(
                                                                height: 22.h,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .animate()
                                                  .moveY(
                                                    begin: 120,
                                                    end: 0,

                                                    curve: Curves.easeOutExpo,
                                                  )
                                                  .fadeIn();
                                            },
                                          );
                                        },

                                        child: Container(
                                          height: 66.h,

                                          decoration: BoxDecoration(
                                            color: accent,

                                            borderRadius: BorderRadius.circular(
                                              28.r,
                                            ),
                                          ),

                                          child: Center(
                                            child: Text(
                                              "Set Wallpaper",

                                              style: GoogleFonts.inter(
                                                color: Colors.white,

                                                fontWeight: FontWeight.w700,

                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 14.w),

                                    ValueListenableBuilder(
                                      valueListenable: isDownloading,

                                      builder: (context, downloading, child) {
                                        return GestureDetector(
                                              onTap: downloading
                                                  ? null
                                                  : () async {
                                                      isDownloading.value =
                                                          true;

                                                      HapticFeedback.mediumImpact();

                                                      final status =
                                                          await Permission
                                                              .photos
                                                              .request();

                                                      if (!status.isGranted) {
                                                        isDownloading.value =
                                                            false;

                                                        _showDone(
                                                          context,
                                                          "Photos permission denied",
                                                        );

                                                        return;
                                                      }

                                                      try {
                                                        final response =
                                                            await http.get(
                                                              Uri.parse(
                                                                widget.imageUrl,
                                                              ),
                                                            );

                                                        final dir =
                                                            await getTemporaryDirectory();

                                                        final file = File(
                                                          '${dir.path}/dotty_wallpaper.jpg',
                                                        );

                                                        await file.writeAsBytes(
                                                          response.bodyBytes,
                                                        );

                                                        await Gal.putImage(
                                                          file.path,
                                                        );

                                                        await Future.delayed(
                                                          const Duration(
                                                            milliseconds: 400,
                                                          ),
                                                        );

                                                        isDownloading.value =
                                                            false;

                                                        HapticFeedback.heavyImpact();

                                                        _showDone(
                                                          context,
                                                          "Wallpaper downloaded successfully",
                                                        );
                                                      } catch (e) {
                                                        isDownloading.value =
                                                            false;

                                                        _showDone(
                                                          context,
                                                          "Something went wrong",
                                                        );
                                                      } catch (e) {
                                                        isDownloading.value =
                                                            false;

                                                        _showDone(
                                                          context,
                                                          "Something went wrong",
                                                        );
                                                      }
                                                    },

                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 500,
                                                ),

                                                curve: Curves.easeOutExpo,

                                                width: 66.w,

                                                height: 66.h,

                                                decoration: BoxDecoration(
                                                  color: downloading
                                                      ? accent
                                                      : Colors.white
                                                            .withOpacity(.06),

                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        26.r,
                                                      ),

                                                  border: Border.all(
                                                    color: downloading
                                                        ? accent
                                                        : Colors.white
                                                              .withOpacity(.06),
                                                  ),
                                                ),

                                                child: AnimatedSwitcher(
                                                  duration: const Duration(
                                                    milliseconds: 400,
                                                  ),

                                                  transitionBuilder:
                                                      (child, animation) {
                                                        return ScaleTransition(
                                                          scale: animation,

                                                          child: child,
                                                        );
                                                      },

                                                  child: downloading
                                                      ? SizedBox(
                                                          key: const ValueKey(
                                                            1,
                                                          ),

                                                          width: 24.w,

                                                          height: 24.h,

                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2.4,

                                                            valueColor:
                                                                const AlwaysStoppedAnimation(
                                                                  Colors.white,
                                                                ),
                                                          ),
                                                        )
                                                      : Icon(
                                                          Hicons
                                                              .downloadLightOutline,

                                                          key: const ValueKey(
                                                            2,
                                                          ),

                                                          color: Colors.white,

                                                          size: 26.sp,
                                                        ),
                                                ),
                                              ),
                                            )
                                            .animate(
                                              target: downloading ? 1 : 0,
                                            )
                                            .scale(
                                              begin: const Offset(1, 1),

                                              end: const Offset(1.08, 1.08),

                                              duration: 600.ms,
                                            );
                                      },
                                    ),
                                  ],
                                ).animate().fadeIn(delay: 800.ms).moveY(begin: 30, end: 0, curve: Curves.easeOutExpo),
                              ],
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 900.ms)
                      .moveY(begin: 100, end: 0, curve: Curves.easeOutExpo)
                      .scale(
                        begin: const Offset(.94, .94),

                        end: const Offset(1, 1),

                        duration: 900.ms,
                      ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getResolution(String url) {
    final match = RegExp(r'(\d+x\d+)').firstMatch(url);

    if (match != null) {
      return match.group(0)!;
    }

    return "HD";
  }

  String getWallpaperName(String url) {
    String fileName = url.split('/').last;

    // remove extension
    fileName = fileName.replaceAll(
      RegExp(r'\.(jpg|jpeg|png|webp)$'),
      '',
    );

    // remove resolution + id
    fileName = fileName.replaceAll(
      RegExp(r'-\d+x\d+-\d+$'),
      '',
    );

    // replace -
    fileName = fileName.replaceAll('-', ' ');

    // capitalize
    return fileName
        .split(' ')
        .map(
          (e) => e.isNotEmpty
          ? e[0].toUpperCase() + e.substring(1)
          : '',
    )
        .join(' ');
  }

  Widget _wallpaperOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color accent,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: EdgeInsets.all(18.w),

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.05),

          borderRadius: BorderRadius.circular(28.r),

          border: Border.all(color: Colors.white.withOpacity(.05)),
        ),

        child: Row(
          children: [
            Container(
              width: 58.w,

              height: 58.h,

              decoration: BoxDecoration(
                color: accent.withOpacity(.14),

                borderRadius: BorderRadius.circular(20.r),
              ),

              child: Icon(icon, color: accent, size: 26.sp),
            ),

            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: GoogleFonts.inter(
                      color: Colors.white,

                      fontSize: 16.sp,

                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  Text(
                    subtitle,

                    style: GoogleFonts.inter(
                      color: Colors.white60,

                      fontSize: 12.sp,

                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,

              color: Colors.white38,

              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setWallpaper({
    required int location,
  }) async {
    try {
      setState(() {
        isSettingWallpaper = true;
      });

      final response = await http.get(
        Uri.parse(widget.imageUrl),
      );

      final dir =
      await getApplicationDocumentsDirectory();

      final file = File(
        '${dir.path}/wallpaper.png',
      );

      await file.writeAsBytes(
        response.bodyBytes,
        flush: true,
      );

      await WallpaperManagerPlus().setWallpaper(
        file,
        location,
      );

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      if (mounted) {
        setState(() {
          isSettingWallpaper = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isSettingWallpaper = false;
        });
      }

      debugPrint('Wallpaper Error: $e');
    }
  }



  void _showDone(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,

        backgroundColor: const Color(0xFF7C4DFF),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),

        content: Text(
          text,

          style: GoogleFonts.inter(
            color: Colors.white,

            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _glassButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),

          child: Container(
            width: 58.w,

            height: 58.h,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.06),

              borderRadius: BorderRadius.circular(24.r),

              border: Border.all(color: Colors.white.withOpacity(.06)),
            ),

            child: Icon(icon, color: iconColor, size: 22.sp),
          ),
        ),
      ),
    );
  }

  Widget _infoChip({required IconData icon, required String text}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.06),

            borderRadius: BorderRadius.circular(20.r),

            border: Border.all(color: Colors.white.withOpacity(.05)),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,

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
