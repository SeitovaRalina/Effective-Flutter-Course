import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

final ThemeData theme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  cardTheme: const CardThemeData(
    elevation: 0,
    color: AppColors.white,
    margin: EdgeInsets.zero,
  ),
  progressIndicatorTheme:
      const ProgressIndicatorThemeData(color: AppColors.blue),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.white,
    surfaceTintColor: AppColors.white,
    shadowColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(18),
      ),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(backgroundColor: AppColors.snackbar),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.roboto(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: 0,
    ),
    headlineSmall: GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      height: 1.2,
      letterSpacing: 0,
    ),
    titleLarge: GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      height: 1.2,
      letterSpacing: 0.4,
    ),
    titleMedium: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0.15,
    ),
    titleSmall: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0.25,
    ),
    labelMedium: GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
      letterSpacing: 0.4,
    ),
  ),
);
