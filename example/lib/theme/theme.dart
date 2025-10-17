import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff485422),
      surfaceTint: Color(0xff586330),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff606c38),
      onPrimaryContainer: Color(0xffdfedac),
      secondary: Color(0xff142005),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff283618),
      onSecondaryContainer: Color(0xff8fa078),
      tertiary: Color(0xff615f4b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfffefae0),
      onTertiaryContainer: Color(0xff75735e),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffcf9f2),
      onSurface: Color(0xff1b1c18),
      onSurfaceVariant: Color(0xff46483c),
      outline: Color(0xff77786b),
      outlineVariant: Color(0xffc7c8b9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff30312c),
      inversePrimary: Color(0xffbfcd8f),
      primaryFixed: Color(0xffdbe9a9),
      onPrimaryFixed: Color(0xff171e00),
      primaryFixedDim: Color(0xffbfcd8f),
      onPrimaryFixedVariant: Color(0xff404b1b),
      secondaryFixed: Color(0xffd7e9bd),
      onSecondaryFixed: Color(0xff121f05),
      secondaryFixedDim: Color(0xffbbcda3),
      onSecondaryFixedVariant: Color(0xff3d4b2b),
      tertiaryFixed: Color(0xffe7e3ca),
      onTertiaryFixed: Color(0xff1d1c0d),
      tertiaryFixedDim: Color(0xffcac7af),
      onTertiaryFixedVariant: Color(0xff494835),
      surfaceDim: Color(0xffdcdad3),
      surfaceBright: Color(0xfffcf9f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f4ec),
      surfaceContainer: Color(0xfff0eee6),
      surfaceContainerHigh: Color(0xffeae8e1),
      surfaceContainerHighest: Color(0xffe4e2db),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbfcd8f),
      surfaceTint: Color(0xffbfcd8f),
      onPrimary: Color(0xff2a3406),
      primaryContainer: Color(0xff606c38),
      onPrimaryContainer: Color(0xffdfedac),
      secondary: Color(0xffbbcda3),
      onSecondary: Color(0xff273517),
      secondaryContainer: Color(0xff283618),
      onSecondaryContainer: Color(0xff8fa078),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff323120),
      tertiaryContainer: Color(0xffe7e3ca),
      onTertiaryContainer: Color(0xff676551),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff131410),
      onSurface: Color(0xffe4e2db),
      onSurfaceVariant: Color(0xffc7c8b9),
      outline: Color(0xff919284),
      outlineVariant: Color(0xff46483c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e2db),
      inversePrimary: Color(0xff586330),
      primaryFixed: Color(0xffdbe9a9),
      onPrimaryFixed: Color(0xff171e00),
      primaryFixedDim: Color(0xffbfcd8f),
      onPrimaryFixedVariant: Color(0xff404b1b),
      secondaryFixed: Color(0xffd7e9bd),
      onSecondaryFixed: Color(0xff121f05),
      secondaryFixedDim: Color(0xffbbcda3),
      onSecondaryFixedVariant: Color(0xff3d4b2b),
      tertiaryFixed: Color(0xffe7e3ca),
      onTertiaryFixed: Color(0xff1d1c0d),
      tertiaryFixedDim: Color(0xffcac7af),
      onTertiaryFixedVariant: Color(0xff494835),
      surfaceDim: Color(0xff131410),
      surfaceBright: Color(0xff393935),
      surfaceContainerLowest: Color(0xff0e0f0b),
      surfaceContainerLow: Color(0xff1b1c18),
      surfaceContainer: Color(0xff1f201c),
      surfaceContainerHigh: Color(0xff2a2a26),
      surfaceContainerHighest: Color(0xff353530),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(bodyColor: colorScheme.onSurface, displayColor: colorScheme.onSurface),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

final appTheme = ThemeData(
  useMaterial3: true,
  appBarTheme: AppBarTheme(backgroundColor: Colors.transparent, foregroundColor: Colors.white, centerTitle: true),
  scaffoldBackgroundColor: Colors.white,
  colorScheme: MaterialTheme.lightScheme(),
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ElevatedButton.styleFrom(
  //     backgroundColor: AppColor.primary,
  //     foregroundColor: Colors.white,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     textStyle: GoogleFonts.varelaRound(
  //       fontSize: 14,
  //       fontWeight: FontWeight.w600,
  //     ),
  //   ),
  // ),
  // outlinedButtonTheme: OutlinedButtonThemeData(
  //   style: OutlinedButton.styleFrom(
  //     foregroundColor: AppColor.primary,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     side: BorderSide(
  //       color: AppColor.primary,
  //     ),
  //     textStyle: GoogleFonts.varelaRound(
  //       fontSize: 14,
  //       fontWeight: FontWeight.w600,
  //     ),
  //   ),
  // ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.varelaRound(fontSize: 72, fontWeight: FontWeight.bold),
    displayMedium: GoogleFonts.varelaRound(fontSize: 56, fontWeight: FontWeight.bold),
    displaySmall: GoogleFonts.varelaRound(fontSize: 40, fontWeight: FontWeight.bold),
    headlineLarge: GoogleFonts.varelaRound(fontSize: 32, fontWeight: FontWeight.w600),
    headlineMedium: GoogleFonts.varelaRound(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: GoogleFonts.varelaRound(fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: GoogleFonts.varelaRound(fontSize: 24, fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.varelaRound(fontSize: 20, fontWeight: FontWeight.bold),
    titleSmall: GoogleFonts.varelaRound(fontSize: 16, fontWeight: FontWeight.bold),
    bodyLarge: GoogleFonts.roboto(fontSize: 18),
    bodyMedium: GoogleFonts.roboto(fontSize: 14),
    bodySmall: GoogleFonts.roboto(fontSize: 12),
    labelLarge: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w600),
    labelMedium: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w600),
    labelSmall: GoogleFonts.roboto(fontSize: 8, fontWeight: FontWeight.w600),
  ),
);
