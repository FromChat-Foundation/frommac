import 'package:flutter/material.dart';

class FromChatTheme {
  static const brandIndigo = Color(0xFF6366F1);
  static const brandPink = Color(0xFFEC4899);
  static const ctaBorderRadius = BorderRadius.all(Radius.circular(38));

  static TextTheme googleSans(TextTheme base) {
    return base.apply(
      fontFamily: 'GoogleSans',
      bodyColor: base.bodyLarge?.color,
      displayColor: base.displayLarge?.color,
    );
  }

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: brandIndigo,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: googleSans(Typography.material2021().black),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: ctaBorderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: brandIndigo,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: googleSans(Typography.material2021().white),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: ctaBorderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
    );
  }
}

class BrandTitle extends StatelessWidget {
  const BrandTitle({super.key, this.fontSize = 28});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [FromChatTheme.brandIndigo, FromChatTheme.brandPink],
      ).createShader(bounds),
      child: Text(
        'FromChat',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}

class MessageBubbleShape extends ShapeBorder {
  const MessageBubbleShape({required this.isMine, this.grouped = false});

  final bool isMine;
  final bool grouped;

  static const large = 20.0;
  static const small = 4.0;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final tl = large;
    final tr = large;
    final bl = isMine ? large : (grouped ? small : large);
    final br = isMine ? (grouped ? small : large) : large;
    return Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: Radius.circular(tl),
          topRight: Radius.circular(tr),
          bottomLeft: Radius.circular(bl),
          bottomRight: Radius.circular(br),
        ),
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
