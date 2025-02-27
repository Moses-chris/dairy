import 'package:flutter/material.dart';
import 'package:myapp/presentation/routes/routes.dart';
import 'package:myapp/presentation/screen/calendar/month_days.dart';
import 'package:myapp/presentation/service/remote_config.dart';
import 'package:myapp/presentation/utils/month_details.dart';

class HomeScreen extends StatefulWidget implements Screen<HomeScreenRoute> {
  @override
  final HomeScreenRoute arg;

  const HomeScreen({
    super.key,
    required this.arg,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ForceAppUpdate.enforcedVersion(context);
  }

  @override
  Widget build(BuildContext context) {

    return MonthScreen(
      monthDetails: MonthDetails(
        year: widget.arg.year ?? DateTime.now().year,
        month: widget.arg.month ?? DateTime.now().month,
        isHomeScreen: true,
      ),
    );
  }
}
