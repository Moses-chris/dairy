import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/domain/models/mood/day.dart';
import 'package:myapp/domain/repository/journal_repo.dart';
import 'package:myapp/presentation/cubits/cubit_state/cubit_state.dart';
import 'package:myapp/presentation/cubits/journal_list_cubit.dart';
import 'package:myapp/presentation/cubits/journal_state.dart';
import 'package:myapp/presentation/injector/injector.dart';
import 'package:myapp/presentation/routes/routes.dart';
import 'package:myapp/presentation/shared/app_bar.dart';
import 'package:myapp/presentation/shared/journal_tile.dart';
import 'package:myapp/presentation/shared/loader.dart';
import 'package:myapp/presentation/utils/extension.dart';
import 'package:myapp/presentation/utils/padding_style.dart';
import 'package:myapp/presentation/widgets/floating_action_button.dart';

class JournalsListScreen extends StatelessWidget
    implements Screen<JournalsListScreenRoute> {
  @override
  final JournalsListScreenRoute arg;

  const JournalsListScreen({
    super.key,
    required this.arg,
  });

  @override
  Widget build(BuildContext context) {
    return JournalList(
      getJournalsByDate: arg.day?.toDateTime() ?? DateTime.now(),
    );
  }
}

class JournalList extends StatelessWidget {
  final DateTime getJournalsByDate;

  const JournalList({
    super.key,
    required this.getJournalsByDate,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    return Scaffold(
      appBar: PrimaryAppBar(
        centerTitle: 'Journals',
        leadingOnTap: () => context.shouldPop(),
      ),
      body: Center(
        child: BlocProvider<JournalListCubit>(
          create: (context) => JournalListCubit(
            journalRepo: Injector.resolve<JournalRepo>(),
          )..getJournalByDate(dateTime: getJournalsByDate),
          child: BlocBuilder<JournalListCubit, CubitState<JournalState>>(
            builder: (context, state) {
              return state.when(
                initial: () => const Loader(),
                loading: () => const Loader(),
                loaded: (journals) {
                  return journals.journals.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Oops! No Journals to read.',
                              style: textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Want to read, Start writing journals.',
                              style: textTheme.bodyLarge,
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: journals.journals.length,
                          padding: const EdgeInsets.symmetric(
                              horizontal: CustomPadding.mediumPadding),
                          itemBuilder: (context, index) {
                            return JournalTile(
                                journal: journals.journals[index]);
                          },
                        );
                },
                error: (e) => Text(e.toString()),
              );
            },
          ),
        ),
      ),
      floatingActionButton: PrimaryFloatingActionButton(
        onTap: () {
          context.pushScreen(
            arg: JournalCreateScreenRoute(
              day: Day(
                year: getJournalsByDate.year,
                month: getJournalsByDate.month,
                day: getJournalsByDate.day,
              ),
            ),
          );
        },
        child: const Image(
          image: AssetImage('assets/icons/calendar_add_on.png'),
          height: 20,
        ),
      ),
    );
  }
}
