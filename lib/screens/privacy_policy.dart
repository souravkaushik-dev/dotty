import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                      "Privacy Policy",

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
                      "PRIVACY",

                      style: GoogleFonts.bebasNeue(
                        color: text,

                        fontSize: 82,

                        height: .9,
                      ),
                    ).animate().fadeIn().moveY(begin: 30, end: 0),

                    const SizedBox(height: 16),

                    Text(
                      "Your privacy and experience matter to us.",

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

            // POLICY CARD
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
                      _sectionTitle("Information Collection", text),

                      _sectionText(
                        "Dotty does not collect personal information such as passwords, payment details, or sensitive user data. The app may temporarily store cached wallpapers and preference settings locally on your device to improve performance and user experience.",

                        secondary,
                      ),

                      const SizedBox(height: 24),

                      _sectionTitle("Wallpaper Sources", text),

                      _sectionText(
                        "Wallpapers displayed inside the application are fetched through APIs and publicly available sources merged into one platform for a seamless browsing experience.",

                        secondary,
                      ),

                      const SizedBox(height: 24),

                      _sectionTitle("Device Storage", text),

                      _sectionText(
                        "Downloaded wallpapers and cached images are stored locally on your device. Users can clear cached data anytime from the preferences section.",

                        secondary,
                      ),

                      const SizedBox(height: 24),

                      _sectionTitle("Third-Party Services", text),

                      _sectionText(
                        "Some services used within Dotty may rely on third-party APIs or image providers. We do not control external platforms or their independent privacy practices.",

                        secondary,
                      ),

                      const SizedBox(height: 24),

                      _sectionTitle("Policy Updates", text),

                      _sectionText(
                        "This privacy policy may be updated in future versions of the application to reflect improvements, features, or legal requirements.",

                        secondary,
                      ),

                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: accent.withOpacity(.12),

                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: Text(
                          "DOTTY • VERSION 3",

                          style: GoogleFonts.inter(
                            color: accent,

                            fontWeight: FontWeight.w700,

                            letterSpacing: 1,

                            fontSize: 11,
                          ),
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
