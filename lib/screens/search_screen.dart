import 'dart:convert';
import 'dart:ui';

import 'package:dotty/screens/previewscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();

  List<Map<String, dynamic>> wallpapers = [];

  List<Map<String, dynamic>> filtered = [];

  final accent = const Color(0xFF7C4DFF);

  final heights = [340.0, 260.0, 390.0, 300.0];

  Future<void> loadData() async {
    final apiUrl = dotenv.env['API_URL'];

    final res = await http.get(Uri.parse(apiUrl!));

    final data = jsonDecode(res.body);

    List<Map<String, dynamic>> all = [];

    data['categories'].forEach((key, value) {
      for (String image in value['wallpapers']) {
        all.add({"image": image, "category": key});
      }
    });

    setState(() {
      wallpapers = all;

      filtered = all;
    });
  }

  @override
  void initState() {
    super.initState();

    loadData();

    controller.addListener(() {
      final query = controller.text.toLowerCase();

      setState(() {
        filtered = wallpapers.where((e) {
          final category =
          e['category'].toString().toLowerCase();

          final image =
          e['image'].toString().toLowerCase();

          final wallpaperName =
          getWallpaperName(image).toLowerCase();

          return category.contains(query) ||
              wallpaperName.contains(query);
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0F1115) : const Color(0xFFF7F8FC);

    final text = isDark ? Colors.white : const Color(0xFF121212);

    final secondary = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: bg,

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [
            // HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // SEARCH BAR
                    Row(
                      children: [
                        // BACK
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22.r),

                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

                              child: Container(
                                width: 58.w,

                                height: 58.h,

                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.05),

                                  borderRadius: BorderRadius.circular(22.r),

                                  border: Border.all(
                                    color: Colors.white.withOpacity(.05),
                                  ),
                                ),

                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,

                                  color: text,

                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 14.w),

                        // SEARCH FIELD
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(26.r),

                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

                              child: Container(
                                height: 58.h,

                                padding: EdgeInsets.symmetric(horizontal: 18.w),

                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.05),

                                  borderRadius: BorderRadius.circular(26.r),

                                  border: Border.all(
                                    color: Colors.white.withOpacity(.05),
                                  ),
                                ),

                                child: TextField(
                                  controller: controller,
                                  textAlignVertical: TextAlignVertical.center,

                                  style: GoogleFonts.inter(
                                    color: text,

                                    fontSize: 15.sp,
                                  ),

                                  decoration: InputDecoration(
                                    border: InputBorder.none,

                                    hintText: "Search wallpapers...",

                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.white54,

                                      fontSize: 14.sp,
                                    ),

                                    icon: Icon(
                                      Icons.search_rounded,

                                      color: Colors.white54,

                                      size: 22.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 34.h),

                    // TITLE
                    Text(
                          "SEARCH",

                          style: GoogleFonts.bebasNeue(
                            color: text,

                            fontSize: 86.sp,

                            height: .9,

                            letterSpacing: 2,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 900.ms)
                        .moveY(begin: 50, end: 0, curve: Curves.easeOutExpo),

                    SizedBox(height: 12.h),

                    // SUBTITLE
                    Text(
                      "${filtered.length} wallpapers discovered across curated collections.",

                      style: GoogleFonts.inter(
                        color: secondary,

                        fontSize: 14.sp,

                        height: 1.8,
                      ),
                    ).animate().fadeIn(delay: 200.ms),

                    SizedBox(height: 20.h),

                    // CHIPS
                    Row(
                      children: [
                        _glassChip(
                          icon: Icons.auto_awesome_rounded,

                          text: "Premium",
                        ),

                        SizedBox(width: 12.w),

                        _glassChip(icon: Icons.bolt_rounded, text: "4K"),

                        SizedBox(width: 12.w),

                        _glassChip(
                          icon: Icons.wallpaper_rounded,

                          text: "${filtered.length}",
                        ),
                      ],
                    ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0),
                  ],
                ),
              ),
            ),

            // EMPTY
            if (filtered.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(
                        Icons.search_off_rounded,

                        size: 80.sp,

                        color: Colors.white24,
                      ),

                      SizedBox(height: 24.h),

                      Text(
                        "No Wallpapers Found",

                        style: GoogleFonts.inter(
                          color: text,

                          fontSize: 26.sp,

                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      Text(
                        "Try searching different categories.",

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

                  childCount: filtered.length,

                  itemBuilder: (context, index) {
                    final item = filtered[index];

                    final image = item['image'];

                    final category = item['category'];

                    return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => PreviewScreen(
                                  imageUrl: image,

                                  category: category,
                                ),
                              ),
                            );
                          },

                          child: Hero(
                            tag: image,

                            child: Container(
                              height: heights[index % 4].h,

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

                                      Colors.black.withOpacity(.78),
                                    ],
                                  ),
                                ),

                                child: Padding(
                                  padding: EdgeInsets.all(18.w),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),

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

                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),

                                            child: Text(
                                              category.toUpperCase(),

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
      ),
    );
  }


  String getWallpaperName(String url) {
    String fileName = url.split('/').last;

    fileName = fileName.replaceAll(
      RegExp(r'\.(jpg|jpeg|png|webp)$'),
      '',
    );

    fileName = fileName.replaceAll(
      RegExp(r'-\d+x\d+-\d+$'),
      '',
    );

    fileName = fileName.replaceAll('-', ' ');

    return fileName
        .split(' ')
        .map(
          (e) => e.isNotEmpty
          ? e[0].toUpperCase() + e.substring(1)
          : '',
    )
        .join(' ');
  }

  Widget _glassChip({required IconData icon, required String text}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.r),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.06),

            borderRadius: BorderRadius.circular(22.r),

            border: Border.all(color: Colors.white.withOpacity(.05)),
          ),

          child: Row(
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
