import 'dart:convert';

import 'package:dotty/screens/preference_screen.dart';
import 'package:dotty/screens/previewscreen.dart';
import 'package:dotty/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../models/category_model.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  bool started = false;

  final Color accent = const Color(0xFF7C4DFF);

  Future<Map<String, dynamic>> fetchData() async {
    final apiUrl = dotenv.env['API_URL'];

    final res = await http.get(Uri.parse(apiUrl!));

    return jsonDecode(res.body);
  }

  void startAutoSlide(int length) {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;

      setState(() {
        currentIndex = (currentIndex + 1) % length;
      });

      startAutoSlide(length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0F1115) : const Color(0xFFF7F8FC);

    final card = isDark ? Colors.white.withOpacity(.04) : Colors.white;

    final text = isDark ? Colors.white : const Color(0xFF121212);

    final secondary = isDark ? Colors.white60 : Colors.black54;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchData(),

          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(color: accent));
            }

            final data = snapshot.data!;

            final trending = data['trending'];

            if (!started) {
              started = true;

              startAutoSlide(trending.length);
            }

            final featuredImage = trending[currentIndex];

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),

              slivers: [
                // HEADER
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 10.h),

                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                "DOTTY",

                                style: GoogleFonts.bebasNeue(
                                  fontSize: 42.sp,

                                  color: text,

                                  letterSpacing: 1.5,
                                ),
                              ),

                              SizedBox(height: 2.h),

                              Text(
                                "Minimal wallpaper collection",

                                style: GoogleFonts.inter(
                                  color: secondary,

                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        _glassIcon(
                          icon: Hicons.search2LightOutline,

                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => const SearchScreen(),
                              ),
                            );
                          },

                          card: card,

                          text: text,
                        ),

                        SizedBox(width: 12.w),

                        _glassIcon(
                          icon: Hicons.filter5LightOutline,

                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => const PreferencesScreen(),
                              ),
                            );
                          },

                          card: card,

                          text: text,
                        ),
                      ],
                    ),
                  ),
                ),

                // FEATURED
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 14.h,
                    ),

                    child:
                        GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) => PreviewScreen(
                                      imageUrl: featuredImage,

                                      category: "Featured",
                                    ),
                                  ),
                                );
                              },

                              child: Hero(
                                tag: featuredImage,

                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 700),

                                  child: Container(
                                    key: ValueKey(featuredImage),

                                    height: 500.h,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(42.r),

                                      image: DecorationImage(
                                        image: NetworkImage(featuredImage),

                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          42.r,
                                        ),

                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,

                                          end: Alignment.bottomCenter,

                                          colors: [
                                            Colors.transparent,

                                            Colors.black.withOpacity(.55),
                                          ],
                                        ),
                                      ),

                                      child: Padding(
                                        padding: EdgeInsets.all(24.w),

                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,

                                          mainAxisAlignment:
                                              MainAxisAlignment.end,

                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 14.w,

                                                vertical: 8.h,
                                              ),

                                              decoration: BoxDecoration(
                                                color: accent,

                                                borderRadius:
                                                    BorderRadius.circular(30.r),
                                              ),

                                              child: Text(
                                                "FEATURED",

                                                style: GoogleFonts.inter(
                                                  color: Colors.white,

                                                  fontWeight: FontWeight.w700,

                                                  letterSpacing: 1,

                                                  fontSize: 11.sp,
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 16.h),

                                            Text(
            getWallpaperName(featuredImage),

                                              style: GoogleFonts.inter(
                                                color: Colors.white,

                                                height: 1,

                                                fontSize: 34.sp,

                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),

                                            SizedBox(height: 14.h),

                                            Text(
                                              "Curated minimal wallpapers crafted to elevate your screen aesthetic.",

                                              style: GoogleFonts.inter(
                                                color: Colors.white70,

                                                fontSize: 14.sp,

                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 700.ms)
                            .scale(begin: const Offset(.95, .95)),
                  ),
                ),

                // CATEGORY TITLE
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 18.h),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          "Categories",

                          style: GoogleFonts.inter(
                            fontSize: 24.sp,

                            fontWeight: FontWeight.w800,

                            color: text,
                          ),
                        ),

                        GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) => const CategoriesPage(),
                                  ),
                                );
                              },

                              child: Text(
                                "Explore",

                                style: GoogleFonts.inter(
                                  color: accent,

                                  fontSize: 14.sp,

                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                            .animate(
                              onPlay: (c) {
                                c.repeat(reverse: true);
                              },
                            )
                            .fade(begin: .6, end: 1, duration: 1400.ms),
                      ],
                    ),
                  ),
                ),

                // CATEGORY LIST
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 190.h,

                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),

                      scrollDirection: Axis.horizontal,

                      itemCount: data['categories'].length,

                      itemBuilder: (context, index) {
                        final categoryName = data['categories'].keys
                            .toList()[index];

                        final category = data['categories'][categoryName];

                        final thumbnail = category['thumbnail'];

                        final wallpapers = category['wallpapers'];

                        return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) => CategoryScreen(
                                      title: categoryName,

                                      wallpapers: List<String>.from(wallpapers),
                                    ),
                                  ),
                                );
                              },

                              child: Container(
                                width: 150.w,

                                margin: EdgeInsets.only(right: 16.w),

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32.r),

                                  image: DecorationImage(
                                    image: NetworkImage(thumbnail),

                                    fit: BoxFit.cover,
                                  ),
                                ),

                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32.r),

                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,

                                      end: Alignment.bottomCenter,

                                      colors: [
                                        Colors.transparent,

                                        Colors.black.withOpacity(.72),
                                      ],
                                    ),
                                  ),

                                  child: Padding(
                                    padding: EdgeInsets.all(18.w),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      mainAxisAlignment: MainAxisAlignment.end,

                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,

                                            vertical: 6.h,
                                          ),

                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              .15,
                                            ),

                                            borderRadius: BorderRadius.circular(
                                              30.r,
                                            ),
                                          ),

                                          child: Text(
                                            "${wallpapers.length} Wallpapers",

                                            style: GoogleFonts.inter(
                                              color: Colors.white,

                                              fontSize: 10.sp,

                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 10.h),

                                        Text(
                                          categoryName,

                                          maxLines: 2,

                                          overflow: TextOverflow.ellipsis,

                                          style: GoogleFonts.inter(
                                            color: Colors.white,

                                            fontSize: 22.sp,

                                            height: 1,

                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: Duration(milliseconds: index * 100))
                            .moveX(begin: 40, end: 0);
                      },
                    ),
                  ),
                ),

                // TRENDING TITLE
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 16.h),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          "Trending",

                          style: GoogleFonts.inter(
                            fontSize: 24.sp,

                            fontWeight: FontWeight.w800,

                            color: text,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                // STAGGERED GRID
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),

                  sliver: SliverToBoxAdapter(
                    child: MasonryGridView.count(
                      physics: const NeverScrollableScrollPhysics(),

                      shrinkWrap: true,

                      crossAxisCount: 2,

                      mainAxisSpacing: 14.h,

                      crossAxisSpacing: 14.w,

                      itemCount: trending.length,

                      itemBuilder: (context, index) {
                        final image = trending[index];

                        return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) => PreviewScreen(
                                      imageUrl: image,

                                      category: "Trending",
                                    ),
                                  ),
                                );
                              },

                              child: Hero(
                                tag: image,

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(28.r),

                                  child: Image.network(
                                    image,

                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: Duration(milliseconds: index * 80))
                            .moveY(begin: 40, end: 0);
                      },
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 140.h)),
              ],
            );
          },
        ),
      ),
    );
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

  Widget _glassIcon({
    required IconData icon,
    required VoidCallback onTap,
    required Color card,
    required Color text,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 54.w,

        height: 54.h,

        decoration: BoxDecoration(
          color: card,

          borderRadius: BorderRadius.circular(20.r),
        ),

        child: Icon(icon, color: text, size: 24.sp),
      ),
    );
  }
}
