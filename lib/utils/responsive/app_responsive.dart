import 'package:firstedu/utils/responsive/context_extension.dart';
import 'package:flutter/material.dart';

class AppResponsive {
  AppResponsive._();

  static double topBarIconButtonSize(BuildContext context) =>
      context.topBarButtonSize;

  static double searchBarHeight(BuildContext context) =>
      context.compactSearchHeight;

  static double filterChipHeight(BuildContext context) =>
      context.compactFilterChipHeight;

  static double categoryChipHeight(BuildContext context) =>
      context.categoryChipHeight;

  static double recommendedCardHeight(BuildContext context) =>
      context.recommendedCardHeight;

  static EdgeInsets pagePadding(BuildContext context) =>
      context.pageHorizontalPadding();

  static double dockBottomSpacing(BuildContext context) =>
      context.dockBottomSpacing;
}