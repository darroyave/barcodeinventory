import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

const primary = Color(0xFF4CB034);
const secondary = Color(0xFF00923F);
const tertiary = Color(0xFF85C226);
const neutral = Color(0xFFE0F5BF);


CustomColors lightCustomColors = const CustomColors(
  sourcePrimary: Color(0xFF4CB034),
  primary: Color(0xFF146E00),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF93FB75),
  onPrimaryContainer: Color(0xFF022100),
  sourceSecondary: Color(0xFF00923F),
  secondary: Color(0xFF006E2D),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF85FB9A),
  onSecondaryContainer: Color(0xFF002109),
  sourceTertiary: Color(0xFF85C226),
  tertiary: Color(0xFF436900),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFB5F657),
  onTertiaryContainer: Color(0xFF112000),
  sourceNeutral: Color(0xFFE0F5BF),
  neutral: Color(0xFF456812),
  onNeutral: Color(0xFFFFFFFF),
  neutralContainer: Color(0xFFC5F08B),
  onNeutralContainer: Color(0xFF112000),
);

CustomColors darkCustomColors = const CustomColors(
  sourcePrimary: Color(0xFF4CB034),
  primary: Color(0xFF77DD5C),
  onPrimary: Color(0xFF063900),
  primaryContainer: Color(0xFF0D5300),
  onPrimaryContainer: Color(0xFF93FB75),
  sourceSecondary: Color(0xFF00923F),
  secondary: Color(0xFF68DE80),
  onSecondary: Color(0xFF003914),
  secondaryContainer: Color(0xFF005320),
  onSecondaryContainer: Color(0xFF85FB9A),
  sourceTertiary: Color(0xFF85C226),
  tertiary: Color(0xFF9AD93D),
  onTertiary: Color(0xFF213600),
  tertiaryContainer: Color(0xFF314F00),
  onTertiaryContainer: Color(0xFFB5F657),
  sourceNeutral: Color(0xFFE0F5BF),
  neutral: Color(0xFFAAD472),
  onNeutral: Color(0xFF203600),
  neutralContainer: Color(0xFF314F00),
  onNeutralContainer: Color(0xFFC5F08B),
);



/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.sourcePrimary,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.sourceSecondary,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.sourceTertiary,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.sourceNeutral,
    required this.neutral,
    required this.onNeutral,
    required this.neutralContainer,
    required this.onNeutralContainer,
  });

  final Color? sourcePrimary;
  final Color? primary;
  final Color? onPrimary;
  final Color? primaryContainer;
  final Color? onPrimaryContainer;
  final Color? sourceSecondary;
  final Color? secondary;
  final Color? onSecondary;
  final Color? secondaryContainer;
  final Color? onSecondaryContainer;
  final Color? sourceTertiary;
  final Color? tertiary;
  final Color? onTertiary;
  final Color? tertiaryContainer;
  final Color? onTertiaryContainer;
  final Color? sourceNeutral;
  final Color? neutral;
  final Color? onNeutral;
  final Color? neutralContainer;
  final Color? onNeutralContainer;

  @override
  CustomColors copyWith({
    Color? sourcePrimary,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? sourceSecondary,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? sourceTertiary,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? sourceNeutral,
    Color? neutral,
    Color? onNeutral,
    Color? neutralContainer,
    Color? onNeutralContainer,
  }) {
    return CustomColors(
      sourcePrimary: sourcePrimary ?? this.sourcePrimary,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      sourceSecondary: sourceSecondary ?? this.sourceSecondary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      sourceTertiary: sourceTertiary ?? this.sourceTertiary,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
      sourceNeutral: sourceNeutral ?? this.sourceNeutral,
      neutral: neutral ?? this.neutral,
      onNeutral: onNeutral ?? this.onNeutral,
      neutralContainer: neutralContainer ?? this.neutralContainer,
      onNeutralContainer: onNeutralContainer ?? this.onNeutralContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      sourcePrimary: Color.lerp(sourcePrimary, other.sourcePrimary, t),
      primary: Color.lerp(primary, other.primary, t),
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t),
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t),
      onPrimaryContainer: Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t),
      sourceSecondary: Color.lerp(sourceSecondary, other.sourceSecondary, t),
      secondary: Color.lerp(secondary, other.secondary, t),
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t),
      secondaryContainer: Color.lerp(secondaryContainer, other.secondaryContainer, t),
      onSecondaryContainer: Color.lerp(onSecondaryContainer, other.onSecondaryContainer, t),
      sourceTertiary: Color.lerp(sourceTertiary, other.sourceTertiary, t),
      tertiary: Color.lerp(tertiary, other.tertiary, t),
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t),
      tertiaryContainer: Color.lerp(tertiaryContainer, other.tertiaryContainer, t),
      onTertiaryContainer: Color.lerp(onTertiaryContainer, other.onTertiaryContainer, t),
      sourceNeutral: Color.lerp(sourceNeutral, other.sourceNeutral, t),
      neutral: Color.lerp(neutral, other.neutral, t),
      onNeutral: Color.lerp(onNeutral, other.onNeutral, t),
      neutralContainer: Color.lerp(neutralContainer, other.neutralContainer, t),
      onNeutralContainer: Color.lerp(onNeutralContainer, other.onNeutralContainer, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///   * [CustomColors.sourceSecondary]
  ///   * [CustomColors.secondary]
  ///   * [CustomColors.onSecondary]
  ///   * [CustomColors.secondaryContainer]
  ///   * [CustomColors.onSecondaryContainer]
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(
      sourceSecondary: sourceSecondary!.harmonizeWith(dynamic.primary),
      secondary: secondary!.harmonizeWith(dynamic.primary),
      onSecondary: onSecondary!.harmonizeWith(dynamic.primary),
      secondaryContainer: secondaryContainer!.harmonizeWith(dynamic.primary),
      onSecondaryContainer: onSecondaryContainer!.harmonizeWith(dynamic.primary),
    );
  }
}