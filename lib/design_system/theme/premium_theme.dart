import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tokens/premium_colors.dart';
import '../tokens/premium_typography.dart';
import '../tokens/premium_spacing.dart';
import '../tokens/premium_radius.dart';
import '../tokens/premium_shadows.dart';

/// Premium Samsung One UI-inspired theme
/// Complete theme system with AMOLED dark and adaptive light modes
class PremiumTheme {
  PremiumTheme._();

  // ============================================================================
  // MAIN THEME GETTERS
  // ============================================================================

  /// Dark theme - AMOLED optimized with pure black background
  static ThemeData get dark => _buildDarkTheme();

  /// Light theme - Clean and professional
  static ThemeData get light => _buildLightTheme();

  // ============================================================================
  // DARK THEME BUILDER
  // ============================================================================

  static ThemeData _buildDarkTheme() {
    final colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: PremiumColors.primary,
      onPrimary: Colors.white,
      primaryContainer: PremiumColors.primaryDark,
      onPrimaryContainer: PremiumColors.primary50,
      secondary: PremiumColors.winning,
      onSecondary: Colors.white,
      secondaryContainer: PremiumColors.winningDark,
      onSecondaryContainer: PremiumColors.winningPale,
      tertiary: PremiumColors.gold,
      onTertiary: Colors.black,
      error: PremiumColors.danger,
      onError: Colors.white,
      errorContainer: PremiumColors.dangerDark,
      onErrorContainer: PremiumColors.dangerPale,
      background: PremiumColors.darkBg,
      onBackground: PremiumColors.darkText,
      surface: PremiumColors.darkSurface2,
      onSurface: PremiumColors.darkText,
      surfaceVariant: PremiumColors.darkSurface3,
      onSurfaceVariant: PremiumColors.darkTextSecondary,
      outline: PremiumColors.darkBorder,
      outlineVariant: PremiumColors.darkBorderSubtle,
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface: PremiumColors.lightSurface1,
      onInverseSurface: PremiumColors.lightText,
      inversePrimary: PremiumColors.primary600,
      surfaceTint: PremiumColors.primary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      
      // Background colors
      scaffoldBackgroundColor: PremiumColors.darkBg,
      canvasColor: PremiumColors.darkBg,
      cardColor: PremiumColors.darkCard,
      dialogBackgroundColor: PremiumColors.darkCardElevated,
      
      // Typography
      fontFamily: PremiumTypography.primaryFont,
      textTheme: _buildTextTheme(isDark: true),
      primaryTextTheme: _buildTextTheme(isDark: true),
      
      // Visual density
      visualDensity: VisualDensity.standard,
      
      // App bar theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: PremiumColors.darkBg,
        surfaceTintColor: Colors.transparent,
        foregroundColor: PremiumColors.darkText,
        iconTheme: const IconThemeData(
          color: PremiumColors.darkText,
          size: 24,
        ),
        actionsIconTheme: const IconThemeData(
          color: PremiumColors.darkText,
          size: 24,
        ),
        titleTextStyle: PremiumTypography.h3.copyWith(
          color: PremiumColors.darkText,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: PremiumColors.darkBg,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: PremiumColors.darkCard,
        shadowColor: Colors.black.withOpacity(0.3),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: PremiumRadius.r20,
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PremiumColors.darkSurface2,
        hoverColor: PremiumColors.darkSurface3,
        contentPadding: PremiumSpacing.input,
        border: OutlineInputBorder(
          borderRadius: PremiumRadius.r12,
          borderSide: const BorderSide(
            color: PremiumColors.darkBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: PremiumRadius.r12,
          borderSide: const BorderSide(
            color: PremiumColors.darkBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: PremiumRadius.r12,
          borderSide: const BorderSide(
            color: PremiumColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: PremiumRadius.r12,
          borderSide: const BorderSide(
            color: PremiumColors.danger,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: PremiumRadius.r12,
          borderSide: const BorderSide(
            color: PremiumColors.danger,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: PremiumRadius.r12,
          borderSide: BorderSide(
            color: PremiumColors.darkBorder.withOpacity(0.5),
            width: 1,
          ),
        ),
        labelStyle: PremiumTypography.body.copyWith(
          color: PremiumColors.darkTextSecondary,
        ),
        floatingLabelStyle: PremiumTypography.caption.copyWith(
          color: PremiumColors.primary,
        ),
        helperStyle: PremiumTypography.caption.copyWith(
          color: PremiumColors.darkTextTertiary,
        ),
        errorStyle: PremiumTypography.caption.copyWith(
          color: PremiumColors.danger,
        ),
        hintStyle: PremiumTypography.body.copyWith(
          color: PremiumColors.darkTextTertiary,
        ),
        prefixIconColor: PremiumColors.darkTextSecondary,
        suffixIconColor: PremiumColors.darkTextSecondary,
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PremiumColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: PremiumColors.darkSurface3,
          disabledForegroundColor: PremiumColors.darkTextDisabled,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: PremiumSpacing.button,
          minimumSize: const Size(120, 52),
          shape: RoundedRectangleBorder(
            borderRadius: PremiumRadius.r16,
          ),
          textStyle: PremiumTypography.button,
        ),
      ),
      
      // Filled button theme (tonal)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: PremiumColors.darkSurface3,
          foregroundColor: PremiumColors.darkText,
          disabledBackgroundColor: PremiumColors.darkSurface2,
          disabledForegroundColor: PremiumColors.darkTextDisabled,
          elevation: 0,
          padding: PremiumSpacing.button,
          minimumSize: const Size(120, 52),
          shape: RoundedRectangleBorder(
            borderRadius: PremiumRadius.r16,
          ),
          textStyle: PremiumTypography.button,
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PremiumColors.darkText,
          disabledForegroundColor: PremiumColors.darkTextDisabled,
          side: const BorderSide(
            color: PremiumColors.darkBorder,
            width: 1.5,
          ),
          padding: PremiumSpacing.button,
          minimumSize: const Size(120, 52),
          shape: RoundedRectangleBorder(
            borderRadius: PremiumRadius.r16,
          ),
          textStyle: PremiumTypography.button,
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: PremiumColors.primary,
          disabledForegroundColor: PremiumColors.darkTextDisabled,
          padding: PremiumSpacing.button,
          minimumSize: const Size(88, 48),
          shape: RoundedRectangleBorder(
            borderRadius: PremiumRadius.r12,
          ),
          textStyle: PremiumTypography.button,
        ),
      ),
      
      // Icon button theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: PremiumColors.darkText,
          disabledForegroundColor: PremiumColors.darkTextDisabled,
          iconSize: 24,
          padding: const EdgeInsets.all(12),
          minimumSize: const Size(48, 48),
        ),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PremiumColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 6,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: PremiumRadius.r16,
        ),
      ),
      
      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: PremiumColors.darkCardElevated,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: PremiumRadius.r24,
        ),
        titleTextStyle: PremiumTypography.h4.copyWith(
          color: PremiumColors.darkText,
        ),
        contentTextStyle: PremiumTypography.body.copyWith(
          color: PremiumColors.darkTextSecondary,
        ),
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: PremiumColors.darkCardElevated,
        modalBackgroundColor: PremiumColors.darkCardElevated,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: PremiumRadius.rTopSheet,
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // Navigation bar theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: PremiumColors.darkSurface1,
        elevation: 0,
        height: 80,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: PremiumColors.primary.withOpacity(0.2),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(
              color: PremiumColors.primary,
              size: 28,
            );
          }
          return const IconThemeData(
            color: PremiumColors.darkTextTertiary,
            size: 24,
          );
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return PremiumTypography.labelSmall.copyWith(
              color: PremiumColors.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return PremiumTypography.labelSmall.copyWith(
            color: PremiumColors.darkTextTertiary,
          );
        }),
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PremiumColors.darkSurface1,
        elevation: 0,
        selectedItemColor: PremiumColors.primary,
        unselectedItemColor: PremiumColors.darkTextTertiary,
        selectedIconTheme: const IconThemeData(
          color: PremiumColors.primary,
          size: 28,
        ),
        unselectedIconTheme: const IconThemeData(
          color: PremiumColors.darkTextTertiary,
          size: 24,
        ),
        selectedLabelStyle: PremiumTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: PremiumTypography.labelSmall,
        type: BottomNavigationBarType.fixed,
      ),
      
      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: PremiumColors.darkSurface3,
        deleteIconColor: PremiumColors.darkTextSecondary,
        disabledColor: PremiumColors.darkSurface2,
        selectedColor: PremiumColors.primary.withOpacity(0.2),
        secondarySelectedColor: PremiumColors.winning.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: PremiumTypography.labelSmall.copyWith(
          color: PremiumColors.darkText,
        ),
        secondaryLabelStyle: PremiumTypography.labelSmall.copyWith(
          color: PremiumColors.darkText,
        ),
        brightness: Brightness.dark,
        elevation: 0,
        pressElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: PremiumRadius.rFull,
        ),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: PremiumColors.darkDivider,
        thickness: 1,
        space: 1,
      ),
      
      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return PremiumColors.darkTextTertiary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return PremiumColors.primary;
          }
          return PremiumColors.darkSurface3;
        }),
      ),
      
      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return PremiumColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      
      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return PremiumColors.primary;
          }
          return PremiumColors.darkBorder;
        }),
      ),
      
      // Snack bar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PremiumColors.darkCardElevated,
        contentTextStyle: PremiumTypography.body.copyWith(
          color: PremiumColors.darkText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: PremiumRadius.r16,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
      
      // Tooltip theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: PremiumColors.darkCardElevated,
          borderRadius: PremiumRadius.r8,
        ),
        textStyle: PremiumTypography.caption.copyWith(
          color: PremiumColors.darkText,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      
      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: PremiumColors.primary,
        linearTrackColor: PremiumColors.darkSurface3,
        circularTrackColor: PremiumColors.darkSurface3,
      ),
      
      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: PremiumColors.primary,
        inactiveTrackColor: PremiumColors.darkSurface3,
        thumbColor: Colors.white,
        overlayColor: PremiumColors.primary.withOpacity(0.2),
        trackHeight: 4,
      ),
      
      // List tile theme
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: PremiumColors.darkSurface2,
        iconColor: PremiumColors.darkTextSecondary,
        textColor: PremiumColors.darkText,
        contentPadding: PremiumSpacing.h20,
        minVerticalPadding: 12,
        shape: RoundedRectangleBorder(
          borderRadius: PremiumRadius.r12,
        ),
      ),
      
      // Expansion tile theme
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        iconColor: PremiumColors.darkTextSecondary,
        textColor: PremiumColors.darkText,
        collapsedIconColor: PremiumColors.darkTextTertiary,
        collapsedTextColor: PremiumColors.darkText,
        childrenPadding: PremiumSpacing.all16,
        shape: RoundedRectangleBorder(
          borderRadius: PremiumRadius.r12,
        ),
      ),
    );
  }

  // ============================================================================
  // LIGHT THEME BUILDER
  // ============================================================================

  static ThemeData _buildLightTheme() {
    final colorScheme = ColorScheme.light(
      brightness: Brightness.light,
      primary: PremiumColors.primary,
      onPrimary: Colors.white,
      primaryContainer: PremiumColors.primary100,
      onPrimaryContainer: PremiumColors.primary900,
      secondary: PremiumColors.success,
      onSecondary: Colors.white,
      secondaryContainer: PremiumColors.successPale,
      onSecondaryContainer: PremiumColors.successDark,
      tertiary: PremiumColors.goldDark,
      onTertiary: Colors.white,
      error: PremiumColors.danger,
      onError: Colors.white,
      errorContainer: PremiumColors.dangerPale,
      onErrorContainer: PremiumColors.dangerDark,
      background: PremiumColors.lightBg,
      onBackground: PremiumColors.lightText,
      surface: PremiumColors.lightSurface1,
      onSurface: PremiumColors.lightText,
      surfaceVariant: PremiumColors.lightSurface2,
      onSurfaceVariant: PremiumColors.lightTextSecondary,
      outline: PremiumColors.lightBorder,
      outlineVariant: PremiumColors.lightBorderSubtle,
      shadow: Colors.black26,
      scrim: Colors.black54,
      inverseSurface: PremiumColors.darkSurface2,
      onInverseSurface: PremiumColors.darkText,
      inversePrimary: PremiumColors.primary300,
      surfaceTint: PremiumColors.primary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      
      scaffoldBackgroundColor: PremiumColors.lightBg,
      canvasColor: PremiumColors.lightBg,
      cardColor: PremiumColors.lightCard,
      dialogBackgroundColor: PremiumColors.lightCard,
      
      fontFamily: PremiumTypography.primaryFont,
      textTheme: _buildTextTheme(isDark: false),
      primaryTextTheme: _buildTextTheme(isDark: false),
      
      visualDensity: VisualDensity.standard,
      
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: PremiumColors.lightBg,
        surfaceTintColor: Colors.transparent,
        foregroundColor: PremiumColors.lightText,
        iconTheme: const IconThemeData(
          color: PremiumColors.lightText,
          size: 24,
        ),
        actionsIconTheme: const IconThemeData(
          color: PremiumColors.lightText,
          size: 24,
        ),
        titleTextStyle: PremiumTypography.h3.copyWith(
          color: PremiumColors.lightText,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: PremiumColors.lightBg,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      
      cardTheme: CardThemeData(
        color: PremiumColors.lightCard,
        shadowColor: Colors.black.withOpacity(0.1),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: PremiumRadius.r20,
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PremiumColors.lightSurface1,
        hoverColor: PremiumColors.lightSurface2,
        contentPadding: PremiumSpacing.input,
        border: OutlineInputBorder(
          borderRadius: PremiumRadius.r12,
          borderSide: const BorderSide(
            color: PremiumColors.lightBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: PremiumRadius.r12,
          borderSide: const BorderSide(
            color: PremiumColors.lightBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: PremiumRadius.r12,
          borderSide: const BorderSide(
            color: PremiumColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: PremiumRadius.r12,
          borderSide: const BorderSide(
            color: PremiumColors.danger,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: PremiumRadius.r12,
          borderSide: const BorderSide(
            color: PremiumColors.danger,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: PremiumRadius.r12,
          borderSide: BorderSide(
            color: PremiumColors.lightBorder.withOpacity(0.5),
            width: 1,
          ),
        ),
        labelStyle: PremiumTypography.body.copyWith(
          color: PremiumColors.lightTextSecondary,
        ),
        floatingLabelStyle: PremiumTypography.caption.copyWith(
          color: PremiumColors.primary,
        ),
        helperStyle: PremiumTypography.caption.copyWith(
          color: PremiumColors.lightTextTertiary,
        ),
        errorStyle: PremiumTypography.caption.copyWith(
          color: PremiumColors.danger,
        ),
        hintStyle: PremiumTypography.body.copyWith(
          color: PremiumColors.lightTextTertiary,
        ),
        prefixIconColor: PremiumColors.lightTextSecondary,
        suffixIconColor: PremiumColors.lightTextSecondary,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PremiumColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: PremiumColors.lightBorderSubtle,
          disabledForegroundColor: PremiumColors.lightTextDisabled,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: PremiumSpacing.button,
          minimumSize: const Size(120, 52),
          shape: RoundedRectangleBorder(
            borderRadius: PremiumRadius.r16,
          ),
          textStyle: PremiumTypography.button,
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: PremiumColors.lightSurface3,
          foregroundColor: PremiumColors.lightText,
          disabledBackgroundColor: PremiumColors.lightBorderSubtle,
          disabledForegroundColor: PremiumColors.lightTextDisabled,
          elevation: 0,
          padding: PremiumSpacing.button,
          minimumSize: const Size(120, 52),
          shape: RoundedRectangleBorder(
            borderRadius: PremiumRadius.r16,
          ),
          textStyle: PremiumTypography.button,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PremiumColors.lightText,
          disabledForegroundColor: PremiumColors.lightTextDisabled,
          side: const BorderSide(
            color: PremiumColors.lightBorder,
            width: 1.5,
          ),
          padding: PremiumSpacing.button,
          minimumSize: const Size(120, 52),
          shape: RoundedRectangleBorder(
            borderRadius: PremiumRadius.r16,
          ),
          textStyle: PremiumTypography.button,
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: PremiumColors.primary,
          disabledForegroundColor: PremiumColors.lightTextDisabled,
          padding: PremiumSpacing.button,
          minimumSize: const Size(88, 48),
          shape: RoundedRectangleBorder(
            borderRadius: PremiumRadius.r12,
          ),
          textStyle: PremiumTypography.button,
        ),
      ),
      
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: PremiumColors.lightText,
          disabledForegroundColor: PremiumColors.lightTextDisabled,
          iconSize: 24,
          padding: const EdgeInsets.all(12),
          minimumSize: const Size(48, 48),
        ),
      ),
      
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PremiumColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        focusElevation: 4,
        hoverElevation: 4,
        highlightElevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: PremiumRadius.r16,
        ),
      ),
      
      dialogTheme: DialogThemeData(
        backgroundColor: PremiumColors.lightCard,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: PremiumRadius.r24,
        ),
        titleTextStyle: PremiumTypography.h4.copyWith(
          color: PremiumColors.lightText,
        ),
        contentTextStyle: PremiumTypography.body.copyWith(
          color: PremiumColors.lightTextSecondary,
        ),
      ),
      
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: PremiumColors.lightCard,
        modalBackgroundColor: PremiumColors.lightCard,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: PremiumRadius.rTopSheet,
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      dividerTheme: const DividerThemeData(
        color: PremiumColors.lightDivider,
        thickness: 1,
        space: 1,
      ),
      
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PremiumColors.lightCard,
        contentTextStyle: PremiumTypography.body.copyWith(
          color: PremiumColors.lightText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: PremiumRadius.r16,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
      
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: PremiumColors.primary,
        linearTrackColor: PremiumColors.lightBorderSubtle,
        circularTrackColor: PremiumColors.lightBorderSubtle,
      ),
    );
  }

  // ============================================================================
  // TEXT THEME BUILDER
  // ============================================================================

  static TextTheme _buildTextTheme({required bool isDark}) {
    final Color textColor = isDark ? PremiumColors.darkText : PremiumColors.lightText;
    final Color textSecondary = isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary;
    
    return TextTheme(
      // Display styles
      displayLarge: PremiumTypography.display1.copyWith(color: textColor),
      displayMedium: PremiumTypography.display2.copyWith(color: textColor),
      displaySmall: PremiumTypography.display3.copyWith(color: textColor),
      
      // Headline styles
      headlineLarge: PremiumTypography.h1.copyWith(color: textColor),
      headlineMedium: PremiumTypography.h2.copyWith(color: textColor),
      headlineSmall: PremiumTypography.h3.copyWith(color: textColor),
      
      // Title styles
      titleLarge: PremiumTypography.h4.copyWith(color: textColor),
      titleMedium: PremiumTypography.h5.copyWith(color: textColor),
      titleSmall: PremiumTypography.h6.copyWith(color: textColor),
      
      // Body styles
      bodyLarge: PremiumTypography.bodyLarge.copyWith(color: textColor),
      bodyMedium: PremiumTypography.body.copyWith(color: textColor),
      bodySmall: PremiumTypography.bodySmall.copyWith(color: textSecondary),
      
      // Label styles
      labelLarge: PremiumTypography.labelLarge.copyWith(color: textColor),
      labelMedium: PremiumTypography.label.copyWith(color: textColor),
      labelSmall: PremiumTypography.labelSmall.copyWith(color: textSecondary),
    );
  }
}
