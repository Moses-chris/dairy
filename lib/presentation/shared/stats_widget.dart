import 'package:flutter/material.dart';
import 'package:myapp/presentation/theme/styling/theme_color_style.dart';
import 'package:myapp/presentation/utils/extension.dart';
import 'package:myapp/presentation/utils/padding_style.dart';

class StatsWidget extends StatelessWidget {
  final String pointsImagePath;
  final int points;
  final String streakImagePath;
  final int streak;

  const StatsWidget({
    super.key,
    required this.pointsImagePath,
    required this.points,
    required this.streakImagePath,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeColorStyle themeColorStyle = context.themeColorStyle;
    final double deviceHeight = context.deviceHeight;
    return Container(
      height: deviceHeight * 0.26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: themeColorStyle.secondaryColor.withOpacity(0.1),
            blurRadius: 100,
          ),
        ],
      ),
      padding:
          const EdgeInsets.symmetric(horizontal: CustomPadding.mediumPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomCard(
            imagePath: pointsImagePath,
            count: points,
            title: 'Points',
          ),
          CustomCard(
            imagePath: streakImagePath,
            count: streak,
            title: 'Streak',
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String imagePath;
  final int count;
  final String title;

  const CustomCard({
    super.key,
    required this.imagePath,
    required this.count,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    final ThemeColorStyle themeColorStyle = context.themeColorStyle;
    final double deviceHeight = context.deviceHeight;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: deviceHeight * 0.035),
          Image(image: AssetImage(imagePath), height: 55),
          SizedBox(height: deviceHeight * 0.025),
          Text(
            '$count',
            style: textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.w700,
                color: themeColorStyle.secondaryColor),
          ),
          SizedBox(height: deviceHeight * 0.02),
          Text(
            title,
            style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
