import 'dart:math' as math;

import 'package:firstedu/utils/responsive/app_breakpoints.dart';
import 'package:flutter/material.dart';

extension ResponsiveContextX on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);

  Size get screenSize => mq.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  EdgeInsets get viewPadding => mq.viewPadding;
  EdgeInsets get viewInsets => mq.viewInsets;

  bool get isSmallPhone => screenWidth < AppBreakpoints.smallPhoneWidth;

  bool get isStandardPhone =>
      screenWidth >= AppBreakpoints.smallPhoneWidth &&
      screenWidth < AppBreakpoints.standardPhoneWidth;

  bool get isLargePhone =>
      screenWidth >= AppBreakpoints.standardPhoneWidth &&
      screenWidth < AppBreakpoints.largePhoneWidth;

  bool get isXLPhone =>
      screenWidth >= AppBreakpoints.largePhoneWidth &&
      screenWidth < 600;

  bool get isTablet => screenWidth >= 600;

  bool get isCompactHeight =>
      screenHeight < AppBreakpoints.compactHeight;

  bool get isTallHeight =>
      screenHeight >= AppBreakpoints.tallHeight;

  double responsive({
    required double xs,
    double? sm,
    double? md,
    double? lg,
    double? tablet,
  }) {
    if (isTablet) return tablet ?? lg ?? md ?? sm ?? xs;
    if (isSmallPhone) return xs;
    if (isStandardPhone) return sm ?? xs;
    if (isLargePhone) return md ?? sm ?? xs;
    return lg ?? md ?? sm ?? xs;
  }
  double responsiveHeight({
    required double compact,
    double? normal,
    double? tall,
    double? tablet,
  }) {
    if (isTablet) return tablet ?? tall ?? normal ?? compact;
    if (isCompactHeight) return compact;
    if (isTallHeight) return tall ?? normal ?? compact;
    return normal ?? compact;
  }
  double scaleWidth(
    double base, {
    double designWidth = 390,
    double minScale = .90,
    double maxScale = 1.10,
    double tabletScale = 1.20,
  }) {
    if (isTablet) {
      return base * tabletScale;
    }

    final scale =
        (screenWidth / designWidth).clamp(minScale, maxScale);

    return base * scale;
  }

  double scaleHeight(
    double base, {
    double designHeight = 844,
    double minScale = .90,
    double maxScale = 1.08,
    double tabletScale = 1.15,
  }) {
    if (isTablet) {
      return base * tabletScale;
    }

    final scale =
        (screenHeight / designHeight).clamp(minScale, maxScale);

    return base * scale;
  }
  double adaptiveRadius(
    double base, {
    double minScale = .92,
    double maxScale = 1.08,
    double tabletScale = 1.15,
  }) {
    if (isTablet) {
      return base * tabletScale;
    }

    final shortest = math.min(screenWidth, screenHeight);

    final scale =
        (shortest / 390).clamp(minScale, maxScale);

    return base * scale;
  }
  double adaptiveFont(
    double base, {
    double minScale = .92,
    double maxScale = 1.08,
    double tabletScale = 1.15,
  }) {
    if (isTablet) {
      return base * tabletScale;
    }

    final scale =
        (screenWidth / 390).clamp(minScale, maxScale);

    return base * scale;
  }
  EdgeInsets pageHorizontalPadding({
    double small = 14,
    double standard = 16,
    double large = 18,
    double xl = 20,
    double tablet = 32,
  }) {
    return EdgeInsets.symmetric(
      horizontal: responsive(
        xs: small,
        sm: standard,
        md: large,
        lg: xl,
        tablet: tablet,
      ),
    );
  }
  double get dockBottomSpacing => responsiveHeight(
        compact: 118,
        normal: 130,
        tall: 138,
        tablet: 150,
      );

  double get topBarButtonSize => responsive(
        xs: 46,
        sm: 50,
        md: 52,
        lg: 54,
        tablet: 58,
      );

  double get compactSearchHeight => responsive(
        xs: 50,
        sm: 54,
        md: 56,
        lg: 58,
        tablet: 60,
      );

  double get compactFilterChipHeight => responsive(
        xs: 38,
        sm: 42,
        md: 44,
        lg: 46,
        tablet: 48,
      );

  double get categoryChipHeight => responsive(
        xs: 42,
        sm: 46,
        md: 48,
        lg: 50,
        tablet: 54,
      );

  double get recommendedCardHeight => responsiveHeight(
        compact: 138,
        normal: 148,
        tall: 156,
        tablet: 170,
      );

  double get compactCardOuterRadius =>
      adaptiveRadius(24);

  double get compactCardInnerRadius =>
      adaptiveRadius(22);

  double get maxContentWidth {
    if (isTablet) {
      return 700;
    }
    return double.infinity;
  }

  Widget constrainContent(Widget child) {
    if (!isTablet) return child;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}