import 'dart:ui';

import 'package:dotty/screens/previewscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatelessWidget {
final String title;

final List<String> wallpapers;

const CategoryScreen({
super.key,
required this.title,
required this.wallpapers,
});

@override
Widget build(BuildContext context) {

final isDark =
Theme.of(context).brightness ==
Brightness.dark;

final accent =
const Color(0xFF7C4DFF);

final bg = isDark
? const Color(0xFF0F1115)
    : const Color(0xFFF7F8FC);

final text = isDark
? Colors.white
    : const Color(0xFF121212);

final secondary = isDark
? Colors.white60
    : Colors.black54;

final heights = [

340.h,

260.h,

390.h,

300.h,
];

return Scaffold(
backgroundColor: bg,

body: CustomScrollView(
physics:
const BouncingScrollPhysics(),

slivers: [

// APPBAR
SliverToBoxAdapter(
child: Padding(
padding:
EdgeInsets.fromLTRB(
20.w,
60.h,
20.w,
10.h,
),

child: Row(
children: [

// BACK
GestureDetector(
onTap: () {

Navigator.pop(
context,
);
},

child: ClipRRect(
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
width:
56.w,

height:
56.h,

decoration:
BoxDecoration(
color: Colors
    .white
    .withOpacity(
.05,
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

child: Icon(
Icons
    .arrow_back_ios_new_rounded,

color:
text,

size:
20.sp,
),
),
),
),
),

SizedBox(
width: 18.w,
),

// TITLE
Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment
    .start,

children: [

Text(
"COLLECTION",

style:
GoogleFonts.inter(
color:
accent,

fontWeight:
FontWeight.w700,

fontSize:
11.sp,

letterSpacing:
1.2,
),
),

SizedBox(
height: 6.h,
),

Text(
title
    .toUpperCase(),

maxLines: 1,

overflow:
TextOverflow
    .ellipsis,

style:
GoogleFonts
    .bebasNeue(
color:
text,

fontSize:
44.sp,

height:
.9,

letterSpacing:
2,
),
),
],
),
),
],
),
),
),

// DESCRIPTION
SliverToBoxAdapter(
child: Padding(
padding:
EdgeInsets.fromLTRB(
24.w,
10.h,
24.w,
26.h,
),

child: Column(
crossAxisAlignment:
CrossAxisAlignment
    .start,

children: [

Text(
"${wallpapers.length} curated premium wallpapers crafted with immersive visuals and ultra minimal aesthetics.",

style:
GoogleFonts.inter(
color:
secondary,

fontSize:
14.sp,

height:
1.8,
),
)
    .animate()
    .fadeIn(
duration:
700.ms,
),

SizedBox(
height: 24.h,
),

// CHIPS
Row(
children: [

_glassChip(
icon:
Icons
    .wallpaper_rounded,

text:
"${wallpapers.length}",
),

SizedBox(
width:
12.w,
),

_glassChip(
icon:
Icons
    .hd_rounded,

text:
"4K",
),

SizedBox(
width:
12.w,
),

_glassChip(
icon:
Icons
    .auto_awesome_rounded,

text:
"Premium",
),
],
)
    .animate()
    .fadeIn(
delay:
200.ms,
)
    .moveY(
begin: 20,
end: 0,
),
],
),
),
),

// EMPTY
if (wallpapers.isEmpty)

SliverFillRemaining(
child: Center(
child: Column(
mainAxisAlignment:
MainAxisAlignment
    .center,

children: [

Icon(
Icons
    .wallpaper_rounded,

size:
82.sp,

color:
Colors.white24,
),

SizedBox(
height:
24.h,
),

Text(
"No Wallpapers",

style:
GoogleFonts.inter(
color:
text,

fontSize:
28.sp,

fontWeight:
FontWeight.w800,
),
),

SizedBox(
height:
10.h,
),

Text(
"New wallpapers will appear soon.",

style:
GoogleFonts.inter(
color:
secondary,

fontSize:
14.sp,
),
),
],
),
),
)

// GRID
else

SliverPadding(
padding:
EdgeInsets.symmetric(
horizontal: 20.w,
),

sliver:
SliverMasonryGrid.count(
crossAxisCount: 2,

mainAxisSpacing:
18.h,

crossAxisSpacing:
18.w,

childCount:
wallpapers.length,

itemBuilder:
(context, index) {

final image =
wallpapers[index];

return GestureDetector(
onTap: () {

Navigator.push(
context,

MaterialPageRoute(
builder: (_) =>
PreviewScreen(
imageUrl:
image,

category:
title,
),
),
);
},

child: Hero(
tag: image,

child:
Container(
height:
heights[index % 4],

decoration:
BoxDecoration(
borderRadius:
BorderRadius.circular(
38.r,
),

image:
DecorationImage(
image:
NetworkImage(
image,
),

fit:
BoxFit.cover,
),
),

child:
Container(
decoration:
BoxDecoration(
borderRadius:
BorderRadius.circular(
38.r,
),

gradient:
LinearGradient(
begin:
Alignment
    .topCenter,

end:
Alignment
    .bottomCenter,

colors: [

Colors.transparent,

Colors.black
    .withOpacity(
.72,
),
],
),
),

child: Padding(
padding:
EdgeInsets.all(
18.w,
),

child: Column(
crossAxisAlignment:
CrossAxisAlignment
    .start,

children: [

ClipRRect(
borderRadius:
BorderRadius.circular(
20.r,
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
20.r,
),
),

child:
Text(
"4K",

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
],
),
),
),
),
),
)
    .animate()

    .fadeIn(
delay: Duration(
milliseconds:
index * 90,
),

duration:
800.ms,
)

    .moveY(
begin: 70,

end: 0,

curve:
Curves
    .easeOutExpo,
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
800.ms,

curve:
Curves
    .easeOutExpo,
)

    .blurXY(
begin: 2,
end: 0,

duration:
600.ms,
);
},
),
),

SliverToBoxAdapter(
child:
SizedBox(
height: 120.h,
),
),
],
),
);
}

Widget _glassChip({
required IconData icon,
required String text,
}) {

return ClipRRect(
borderRadius:
BorderRadius.circular(
22.r,
),

child: BackdropFilter(
filter: ImageFilter.blur(
sigmaX: 12,
sigmaY: 12,
),

child: Container(
padding:
EdgeInsets.symmetric(
horizontal: 16.w,
vertical: 10.h,
),

decoration:
BoxDecoration(
color: Colors.white
    .withOpacity(.06),

borderRadius:
BorderRadius.circular(
22.r,
),

border: Border.all(
color: Colors.white
    .withOpacity(.05),
),
),

child: Row(
children: [

Icon(
icon,

color:
Colors.white70,

size: 18.sp,
),

SizedBox(
width: 8.w,
),

Text(
text,

style:
GoogleFonts.inter(
color:
Colors.white,

fontWeight:
FontWeight.w600,

fontSize:
12.sp,
),
),
],
),
),
),
);
}
}
