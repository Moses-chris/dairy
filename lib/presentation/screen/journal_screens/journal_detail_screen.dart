import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/domain/models/journal/journal.dart';
import 'package:myapp/domain/repository/journal_repo.dart';
import 'package:myapp/presentation/cubits/cubit_state/cubit_state.dart';
import 'package:myapp/presentation/cubits/journal_detail_cubit.dart';
import 'package:myapp/presentation/injector/injector.dart';
import 'package:myapp/presentation/routes/routes.dart';
import 'package:myapp/presentation/shared/app_bar.dart';
import 'package:myapp/presentation/shared/dialog_box.dart';
import 'package:myapp/presentation/shared/loader.dart';
import 'package:myapp/presentation/theme/styling/theme_color_style.dart';
import 'package:myapp/presentation/utils/calendar.dart';
import 'package:myapp/presentation/utils/extension.dart';
import 'package:myapp/presentation/utils/padding_style.dart';
import 'package:myapp/presentation/widgets/floating_action_button.dart';

class JournalDetailScreen extends StatelessWidget
    implements Screen<JournalDetailScreenRoute> {
  @override
  final JournalDetailScreenRoute arg;
  const JournalDetailScreen({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = context.deviceHeight;

    return BlocProvider<JournalDetailCubit>(
      create: (context) => JournalDetailCubit(
        journalRepo: Injector.resolve<JournalRepo>(),
      )..journalById$(journalId: arg.id),
      child: BlocBuilder<JournalDetailCubit, CubitState<Journal>>(
        builder: (context, state) {
          return state.when(
            initial: () => const ScaffoldLoader(),
            loading: () => const ScaffoldLoader(),
            loaded: (journal) {
              return Scaffold(
                appBar: PrimaryAppBar(
                  leadingOnTap: () => context.shouldPop(),
                  centerTitle: 'Mood Journal',
                  trailingText: 'Delete',
                  trailingOnTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialogBox(journalId: arg.id),
                    );
                  },
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CustomPadding.mediumPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: deviceHeight * 0.06),
                        MoodWidget(
                          date: journal.createdAt,
                          moodColor: journal.mood.color,
                          mood: journal.mood.label,
                        ),
                        SizedBox(height: deviceHeight * 0.04),
                        DocumentWidget(
                          title: 'Title',
                          description: journal.title,
                        ),
                        SizedBox(height: deviceHeight * 0.02),
                        DocumentWidget(
                          title: 'Note',
                          description: journal.memo,
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: PrimaryFloatingActionButton(
                  onTap: () {
                    context.pushScreen(
                      arg: JournalEditScreenRoute(id: journal.id),
                    );
                  },
                  child: const Icon(Icons.edit_outlined),
                ),
              );
            },
            error: (e) => Text(e.toString()),
          );
        },
      ),
    );
  }
}

class MoodWidget extends StatelessWidget {
  final DateTime date;
  final int moodColor;
  final String mood;

  const MoodWidget({
    super.key,
    required this.date,
    required this.moodColor,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    final ThemeColorStyle themeColorStyle = context.themeColorStyle;
    final double deviceHeight = context.deviceHeight;
    final double deviceWidth = context.deviceWidth;
    final formattedDate =
        '${date.day} ${CalendarUtils.getFullMonthName(date.month)} ${date.year}';
    return SizedBox(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            formattedDate,
            style: textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w500,
                color: themeColorStyle.secondaryColor),
          ),
          SizedBox(height: deviceHeight * 0.04),
          CircleAvatar(
            backgroundColor: Color(moodColor),
            radius: deviceWidth * 0.075,
          ),
          SizedBox(height: deviceHeight * 0.02),
          Text(
            mood,
            style:
                textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class DocumentWidget extends StatelessWidget {
  final String title;
  final String description;

  const DocumentWidget({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    final ThemeColorStyle themeColorStyle = context.themeColorStyle;
    final double deviceHeight = context.deviceHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: themeColorStyle.secondaryColor),
        ),
        SizedBox(height: deviceHeight * 0.01),
        Text(
          description,
          style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
