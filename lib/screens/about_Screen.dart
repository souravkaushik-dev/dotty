import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Provider/version_provider.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0F1115) : const Color(0xFFF7F8FC);

    final text = isDark ? Colors.white : const Color(0xFF121212);

    final secondary = isDark ? Colors.white60 : Colors.black54;

    final accent = const Color(0xFF7C4DFF);

    return Scaffold(
      backgroundColor: bg,

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [
            // HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),

                child: Row(
                  children: [
                    _glassButton(
                      icon: Icons.arrow_back_ios_new_rounded,

                      onTap: () {
                        Navigator.pop(context);
                      },

                      text: text,
                    ),

                    const SizedBox(width: 16),

                    Text(
                      "About App",

                      style: GoogleFonts.inter(
                        color: text,

                        fontSize: 28,

                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // HERO
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "DOTTY",

                      style: GoogleFonts.bebasNeue(
                        color: text,

                        fontSize: 84,

                        height: .9,

                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn().moveY(begin: 30, end: 0),

                    const SizedBox(height: 16),

                    Text(
                      "Immersive wallpapers crafted for modern setups and premium visual aesthetics.",

                      style: GoogleFonts.inter(
                        color: secondary,

                        fontSize: 15,

                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // CONTENT
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.04),

                    borderRadius: BorderRadius.circular(34),

                    border: Border.all(color: Colors.white.withOpacity(.04)),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // VERSION
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: accent.withOpacity(.12),

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          "BUILD ${AppInfo.buildNumber} • ${AppInfo.buildCodename}",

                          style: GoogleFonts.inter(
                            color: accent,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            fontSize: 11,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "About Dotty",

                        style: GoogleFonts.inter(
                          color: text,

                          fontSize: 26,

                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "All wallpapers you are viewing inside Dotty are delivered through multiple APIs and sources merged together into one premium experience. Our system collects high-quality wallpapers from various platforms to provide a smooth and immersive wallpaper discovery experience.",

                        style: GoogleFonts.inter(
                          color: secondary,

                          fontSize: 15,

                          height: 1.9,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "Dotty is the third renewed version of our wallpaper application, redesigned with a cleaner visual language, smoother animations, modern glass aesthetics, and a more immersive browsing experience.",

                        style: GoogleFonts.inter(
                          color: secondary,

                          fontSize: 15,

                          height: 1.9,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "This version focuses on premium UI design, cinematic presentation, fast performance, and curated wallpaper collections crafted for modern devices.",

                        style: GoogleFonts.inter(
                          color: secondary,

                          fontSize: 15,

                          height: 1.9,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).moveY(begin: 30, end: 0),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _glassButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color text,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

          child: Container(
            width: 54,

            height: 54,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),

              borderRadius: BorderRadius.circular(20),

              border: Border.all(color: Colors.white.withOpacity(.05)),
            ),

            child: Icon(icon, color: text),
          ),
        ),
      ),
    );
  }
}
