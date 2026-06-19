import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
                      "Terms & Conditions",

                      style: GoogleFonts.inter(
                        color: text,

                        fontSize: 26,

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
                      "TERMS",

                      style: GoogleFonts.bebasNeue(
                        color: text,

                        fontSize: 82,

                        height: .9,
                      ),
                    ).animate().fadeIn().moveY(begin: 30, end: 0),

                    const SizedBox(height: 16),

                    Text(
                      "Guidelines and conditions for using Dotty.",

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
                      _sectionTitle("Wallpaper Usage", text),

                      _sectionText(
                        "Wallpapers available inside Dotty are intended for personal use and visual customization purposes. Users are responsible for respecting original creators and external content sources where applicable.",

                        secondary,
                      ),

                      const SizedBox(height: 24),

                      _sectionTitle("Content Sources", text),

                      _sectionText(
                        "Dotty aggregates wallpapers from APIs and publicly available platforms to provide a seamless browsing experience. We do not claim ownership of every image displayed inside the application.",

                        secondary,
                      ),

                      const SizedBox(height: 24),

                      _sectionTitle("Application Experience", text),

                      _sectionText(
                        "Users agree to use the application responsibly and avoid misuse, reverse engineering, automated scraping, or actions that may harm platform performance.",

                        secondary,
                      ),

                      const SizedBox(height: 24),

                      _sectionTitle("Updates & Changes", text),

                      _sectionText(
                        "Features, interface design, policies, and services may evolve over future versions of Dotty without prior notice in order to improve the user experience.",

                        secondary,
                      ),

                      const SizedBox(height: 24),

                      _sectionTitle("Acceptance", text),

                      _sectionText(
                        "By using Dotty, users acknowledge and accept these terms and conditions as part of the platform experience.",

                        secondary,
                      ),

                      const SizedBox(height: 40),

                      // SIGNATURE
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 60,

                              height: 1,

                              color: Colors.white.withOpacity(.08),
                            ),

                            const SizedBox(height: 18),

                            Text(
                              "DOTSTUDIOS",

                              style: GoogleFonts.bebasNeue(
                                color: accent,

                                fontSize: 34,

                                letterSpacing: 2,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Crafting immersive digital experiences.",

                              textAlign: TextAlign.center,

                              style: GoogleFonts.inter(
                                color: secondary,

                                fontSize: 13,
                              ),
                            ),
                          ],
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

  Widget _sectionTitle(String title, Color text) {
    return Text(
      title,

      style: GoogleFonts.inter(
        color: text,

        fontSize: 20,

        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _sectionText(String text, Color secondary) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),

      child: Text(
        text,

        style: GoogleFonts.inter(color: secondary, fontSize: 14, height: 1.9),
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
