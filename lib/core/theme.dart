import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

enum AppThemeMode { clay, dark, purpleNeo, cutePastel, minimalLight, generated }

class CustomThemeColors {
  final Color bgColor;
  final Color cardColor;
  final Color primaryColor;
  final Color textColor;

  CustomThemeColors({
    required this.bgColor,
    required this.cardColor,
    required this.primaryColor,
    required this.textColor,
  });

  Map<String, int> toMap() {
    return {
      'bgColor': bgColor.value,
      'cardColor': cardColor.value,
      'primaryColor': primaryColor.value,
      'textColor': textColor.value,
    };
  }

  factory CustomThemeColors.fromMap(Map<dynamic, dynamic> map) {
    return CustomThemeColors(
      bgColor: Color(map['bgColor']),
      cardColor: Color(map['cardColor']),
      primaryColor: Color(map['primaryColor']),
      textColor: Color(map['textColor']),
    );
  }
}

class ThemeManager extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _keyTheme = 'theme_mode';
  static const String _keyCustomColors = 'custom_theme_colors';

  AppThemeMode _currentMode = AppThemeMode.clay;
  CustomThemeColors? _customColors;

  ThemeManager() {
    _loadTheme();
  }

  AppThemeMode get currentMode => _currentMode;
  CustomThemeColors? get customColors => _customColors;

  void setTheme(AppThemeMode mode) {
    _currentMode = mode;
    _saveTheme(mode);
    notifyListeners();
  }

  void setGeneratedTheme(CustomThemeColors colors) {
    _customColors = colors;
    _currentMode = AppThemeMode.generated;
    _saveTheme(AppThemeMode.generated);
    _saveCustomColors(colors);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final box = await Hive.openBox(_boxName);
    final dynamic savedValue = box.get(_keyTheme);

    int? savedIndex;
    if (savedValue is int) {
      savedIndex = savedValue;
    } else if (savedValue is String) {
      savedIndex = int.tryParse(savedValue);
    }

    if (savedIndex != null &&
        savedIndex >= 0 &&
        savedIndex < AppThemeMode.values.length) {
      _currentMode = AppThemeMode.values[savedIndex];
    }

    final dynamic savedColors = box.get(_keyCustomColors);
    if (savedColors != null) {
      _customColors = CustomThemeColors.fromMap(savedColors);
    }

    notifyListeners();
  }

  Future<void> _saveTheme(AppThemeMode mode) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_keyTheme, mode.index);
  }

  Future<void> _saveCustomColors(CustomThemeColors colors) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_keyCustomColors, colors.toMap());
  }
}

class AppColors {
  // Clay Theme Colors
  static const Color green50 = Color(0xFFF0FDF4);
  static const Color green100 = Color(0xFFDCFCE7);
  static const Color green200 = Color(0xFFBBF7D0);
  static const Color green300 = Color(0xFF86EFAC);
  static const Color green400 = Color(0xFF4ADE80);
  static const Color green500 = Color(0xFF22C55E);
  static const Color green600 = Color(0xFF16A34A);
  static const Color green700 = Color(0xFF15803D);
  static const Color green800 = Color(0xFF166534);
  static const Color green900 = Color(0xFF14532D);

  static const Color cream = Color(0xFFFFF8F0);
  static const Color creamBorder = Color(0xFFA5F3C2);

  // Pastels
  static const Color orange100 = Color(0xFFFFEDD5);
  static const Color orange400 = Color(0xFFFB923C);
  static const Color orange500 = Color(0xFFF97316);

  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color blue200 = Color(0xFFBFDBFE);
  static const Color blue400 = Color(0xFF60A5FA);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB); // Added
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color blue800 = Color(0xFF1E40AF);
  static const Color blue900 = Color(0xFF1E3A8A);

  static const Color purple50 = Color(0xFFFAF5FF);
  static const Color purple100 = Color(0xFFF3E8FF);
  static const Color purple200 = Color(0xFFE9D5FF);
  static const Color purple400 = Color(0xFFC084FC);
  static const Color purple500 = Color(0xFFA855F7); // Added
  static const Color purple600 = Color(0xFF9333EA);
  static const Color purple700 = Color(0xFF7E22CE);

  static const Color pink50 = Color(0xFFFDF2F8);
  static const Color pink100 = Color(0xFFFCE7F3);
  static const Color pink300 = Color(0xFFF9A8D4);
  static const Color pink400 = Color(0xFFF472B6);
  static const Color pink500 = Color(0xFFEC4899);
  static const Color pink600 = Color(0xFFDB2777);

  static const Color yellow50 = Color(0xFFFEFCE8);
  static const Color yellow100 = Color(0xFFFEF9C3);
  static const Color yellow200 = Color(0xFFFEF08A);
  static const Color yellow600 = Color(0xFFCA8A04);
  static const Color yellow700 = Color(0xFFA16207);

  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827); // Added

  // Legacy mappings for compatibility
  static const Color primaryDeep = green900;
  static const Color primaryMedium = green600;
  static const Color primaryLight = green400; // Added
  static const Color primaryGradientMiddle =
      green500; // Added for legacy support
  static const Color glowAccent = green400;
  static const Color pastelBlue = blue100;
  static const Color pastelPink = pink100;
  static const Color pastelYellow = yellow100;
  static const Color pastelMint = green100;
  static const Color pastelOrange = orange100;

  // Missing Legacy Members
  static const Color textPrimary = gray800; // Added
  static const Color textSecondary = gray500;
  static const Color textDark = gray800; // Added
  static const Color gray300 = Color(0xFFD1D5DB);
  static final Color cardGlass = Colors.white.withOpacity(0.8);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [green400, green600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static const double kButtonHeight = 52.0;
  static const double kIconSize = 24.0;
  static const double kCardRadius = 24.0;
  static const double kPadding = 16.0;

  static BoxShadow glowShadow = BoxShadow(
    color: AppColors.green400.withOpacity(0.4),
    blurRadius: 12,
    spreadRadius: 2,
  );

  static BoxShadow softShadow = BoxShadow(
    // Added
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static ThemeData getTheme(
    AppThemeMode mode, {
    CustomThemeColors? customColors,
  }) {
    if (mode == AppThemeMode.generated && customColors != null) {
      return _buildCustomTheme(customColors);
    }

    switch (mode) {
      case AppThemeMode.dark:
      case AppThemeMode.purpleNeo: // Legacy
        return _clayTheme;
      case AppThemeMode.cutePastel: // Legacy
      case AppThemeMode.minimalLight: // Legacy
      case AppThemeMode.clay:
      case AppThemeMode.generated: // Fallback if customColors is null
        return _clayTheme;
    }
  }

  static ThemeData _buildCustomTheme(CustomThemeColors colors) {
    return ThemeData(
      brightness: Brightness.light, // Or determine based on bgColor luminance
      scaffoldBackgroundColor: colors.bgColor,
      primaryColor: colors.primaryColor,
      colorScheme: ColorScheme.light(
        primary: colors.primaryColor,
        secondary: colors.primaryColor.withOpacity(0.8),
        surface: colors.cardColor,
        onSurface: colors.textColor,
      ),
      textTheme: _buildTextTheme(colors.textColor),
      iconTheme: IconThemeData(
        color: colors.textColor.withOpacity(0.8),
        size: kIconSize,
      ),
      useMaterial3: true,
      fontFamily: GoogleFonts.nunito().fontFamily,
    );
  }

  static final ThemeData _clayTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.green100,
    primaryColor: AppColors.green500,
    colorScheme: const ColorScheme.light(
      primary: AppColors.green500,
      secondary: AppColors.orange400,
      surface: AppColors.cream,
      onSurface: AppColors.gray800,
    ),
    textTheme: _buildTextTheme(AppColors.gray800),
    iconTheme: const IconThemeData(color: AppColors.gray600, size: kIconSize),
    useMaterial3: true,
    fontFamily: GoogleFonts.nunito().fontFamily,
  );

  static TextTheme _buildTextTheme(Color color) {
    return TextTheme(
      displayLarge: GoogleFonts.fredoka(
        fontSize: 32,
        fontWeight: FontWeight.w900, // Black
        color: color,
      ),
      displayMedium: GoogleFonts.fredoka(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: color,
      ),
      displaySmall: GoogleFonts.fredoka(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: color,
      ),
      headlineMedium: GoogleFonts.fredoka(
        fontSize: 20,
        fontWeight: FontWeight.w700, // Bold
        color: color,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color.withOpacity(0.8),
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color.withOpacity(0.6),
      ),
    );
  }
}
