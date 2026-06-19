import 'dart:ui';

import 'package:dotty/screens/privacy_policy.dart';
import 'package:dotty/screens/terms_condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Provider/theme_provider.dart';
import '../Provider/version_provider.dart';
import 'about_Screen.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final accent = const Color(0xFF7C4DFF);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0F1115) : const Color(0xFFF7F8FC);

    final text = isDark ? Colors.white : const Color(0xFF121212);

    final secondary = isDark ? Colors.white60 : Colors.black54;

    final card = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.white.withOpacity(0.8);

    return Scaffold(
      backgroundColor: bg,

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        _glassButton(
                          icon: Hicons.left2LightOutline,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          text: text,
                          card: card,
                          isDark: isDark,
                        ),

                        SizedBox(width: 16.w),

                        Text(
                          "Preferences",
                          style: GoogleFonts.inter(
                            color: text,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 34.h),

                    Text(
                      "SETTINGS",
                      style: GoogleFonts.bebasNeue(
                        color: text,
                        fontSize: 92.sp,
                        height: .9,
                        letterSpacing: 2,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 900.ms)
                        .moveY(begin: 60, end: 0),

                    SizedBox(height: 14.h),

                    Text(
                      "Customize your wallpaper experience with immersive personalization and premium preferences.",
                      style: GoogleFonts.inter(
                        color: secondary,
                        fontSize: 15.sp,
                        height: 1.8,
                      ),
                    ).animate().fadeIn(delay: 200.ms),

                    SizedBox(height: 22.h),

                    Row(
                      children: [
                        _glassChip(
                          icon: Hicons.colorPickerLightOutline,
                          text: "Theme",
                          textColor: text,
                          secondary: secondary,
                          card: card,
                          isDark: isDark,
                        ),

                        SizedBox(width: 12.w),

                        _glassChip(
                          icon: Icons.auto_awesome_rounded,
                          text: "Premium",
                          textColor: text,
                          secondary: secondary,
                          card: card,
                          isDark: isDark,
                        ),

                        SizedBox(width: 12.w),

                        _glassChip(
                          icon: Hicons.settingLightOutline,
                          text: AppInfo.buildCodename,
                          textColor: text,
                          secondary: secondary,
                          card: card,
                          isDark: isDark,
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

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),

              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _settingTile(
                    icon: Hicons.moonLightOutline,
                    title: "Dark Mode",
                    subtitle: "Enable immersive dark appearance",
                    text: text,
                    secondary: secondary,
                    accent: accent,
                    card: card,
                    isDark: isDark,
                    trailing: Switch(
                      value: themeProvider.isDark,
                      activeColor: accent,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                    ),
                  ),

                  SizedBox(height: 18.h),

                  _settingTile(
                    icon: Hicons.minusLightOutline,
                    title: "Clear Cache",
                    subtitle:
                    "Remove temporary wallpapers and cached files",
                    text: text,
                    secondary: secondary,
                    accent: accent,
                    card: card,
                    isDark: isDark,
                    trailing: Icon(
                      Hicons.right2LightOutline,
                      color: secondary,
                      size: 16.sp,
                    ),
                    onTap: () async {
                      await DefaultCacheManager().emptyCache();

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          content: Text(
                            "Wallpaper cache cleared",
                            style: GoogleFonts.inter(
                              color: isDark
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 18.h),

                  _settingTile(
                    icon: Hicons.informationSquareLightOutline,
                    title: "About App",
                    subtitle: "Learn more about Dotty",
                    text: text,
                    secondary: secondary,
                    accent: accent,
                    card: card,
                    isDark: isDark,
                    trailing: Icon(
                      Hicons.right2LightOutline,
                      color: secondary,
                      size: 16.sp,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutAppScreen(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 18.h),

                  _settingTile(
                    icon: Hicons.shield1LightOutline,
                    title: "Privacy Policy",
                    subtitle: "Understand how your data is handled",
                    text: text,
                    secondary: secondary,
                    accent: accent,
                    card: card,
                    isDark: isDark,
                    trailing: Icon(
                      Hicons.right2LightOutline,
                      color: secondary,
                      size: 16.sp,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 18.h),

                  _settingTile(
                    icon:
                    Hicons.documentAlignCenter1LightOutline,
                    title: "Terms & Conditions",
                    subtitle:
                    "Review usage guidelines and policies",
                    text: text,
                    secondary: secondary,
                    accent: accent,
                    card: card,
                    isDark: isDark,
                    trailing: Icon(
                      Hicons.right2LightOutline,
                      color: secondary,
                      size: 16.sp,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const TermsConditionsScreen(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 120.h),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color text,
    required Color card,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

          child: Container(
            width: 58.w,
            height: 58.h,

            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(22.r),
            ),

            child: Icon(icon, color: text, size: 20.sp),
          ),
        ),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required Color text,
    required Color secondary,
    required Color accent,
    required Color card,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: EdgeInsets.all(20.w),

        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(32.r),
        ),

        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.h,

              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(.1)
                    : Colors.black.withOpacity(.05),
                borderRadius: BorderRadius.circular(20.r),
              ),

              child: Icon(icon, color: accent, size: 24.sp),
            ),

            SizedBox(width: 18.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: text,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.sp,
                    ),
                  ),

                  SizedBox(height: 7.h),

                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: secondary,
                      fontSize: 12.sp,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            trailing,
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 700.ms)
        .moveY(begin: 40, end: 0);
  }

  Widget _glassChip({
    required IconData icon,
    required String text,
    required Color textColor,
    required Color secondary,
    required Color card,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 10.h,
      ),

      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(22.r),
      ),

      child: Row(
        children: [
          Icon(icon, color: secondary, size: 18.sp),

          SizedBox(width: 8.w),

          Text(
            text,
            style: GoogleFonts.inter(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}