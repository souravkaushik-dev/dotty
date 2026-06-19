class AppInfo {

  static const String versionName = "1.0.0";

  static const String buildNumber = "1";

  static const String buildCodename = "Aurora";

  static const String releaseType = "Stable";
  static String get display =>
      "Wallpaper App v$versionName ($buildNumber) · $buildCodename";

  static String get fullInfo =>
      "Version $versionName+$buildNumber | $buildCodename | $releaseType";
}