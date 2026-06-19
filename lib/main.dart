import 'package:dotty/onboarding/onboard.dart';
import 'package:dotty/onboarding/splash_screen.dart';
import 'package:dotty/screens/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'Provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScreenUtilInit(
      // YOUR DESIGN SIZE
      designSize: const Size(430, 932),

      minTextAdapt: true,

      splitScreenMode: true,

      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          themeMode: themeProvider.themeMode,

          darkTheme: ThemeData(
            brightness: Brightness.dark,

            scaffoldBackgroundColor: const Color(0xFF0F1115),
          ),

          theme: ThemeData(
            brightness: Brightness.light,

            scaffoldBackgroundColor: const Color(0xFFF7F8FC),
          ),

          home: const SplashScreen(),
        );
      },
    );
  }
}
