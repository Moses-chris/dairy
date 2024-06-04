import 'package:flutter/material.dart';
import 'package:myapp/presentation/routes/routes.dart';
import 'package:myapp/presentation/screen/analytics_screens/monthly_analytics.dart';
import 'package:myapp/presentation/screen/analytics_screens/weekly_analytics.dart';
import 'package:myapp/presentation/shared/app_bar.dart';
import 'package:myapp/presentation/theme/styling/theme_color_style.dart';
import 'package:myapp/presentation/utils/extension.dart';
import 'package:myapp/presentation/widgets/gradient_scaffold.dart';

class AnalyticsScreen extends StatelessWidget
    implements Screen<AnalyticsScreenRoute> {
  @override
  final AnalyticsScreenRoute arg;

  const AnalyticsScreen({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    return const AnalyticsTabBarView();
  }
}

class AnalyticsTabBarView extends StatefulWidget {
  const AnalyticsTabBarView({super.key});

  @override
  State<AnalyticsTabBarView> createState() => _AnalyticsTabBarViewState();
}

class _AnalyticsTabBarViewState extends State<AnalyticsTabBarView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    final ThemeColorStyle themeColorStyle = context.themeColorStyle;
    final double deviceHeight = context.deviceHeight;
    final double deviceWidth = context.deviceWidth;
    return DefaultTabController(
      length: 2,
      child: GradientScaffold(
        appBar: PrimaryAppBar(
          leadingOnTap: () => context.shouldPop(),
          centerTitle: 'Analytics',
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: deviceHeight * 0.05),
            Container(
              width: deviceWidth * 0.56,
              height: deviceHeight * 0.055,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: themeColorStyle.secondaryColor.withOpacity(0.03),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: themeColorStyle.tertiaryColor,
                unselectedLabelStyle:
                    textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w400),
                labelColor: themeColorStyle.quinaryColor,
                labelStyle:
                    textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: themeColorStyle.secondaryColor,
                ),
                tabs: const [
                  Tab(text: 'Weekly'),
                  Tab(text: 'Monthly'),
                ],
              ),
            ),
            SizedBox(height: deviceHeight * 0.06),
            SizedBox(
              height: deviceHeight * 0.7,
              child: TabBarView(
                controller: _tabController,
                children: const [
                  WeeklyAnalyticsTab(),
                  MonthlyAnalyticsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
