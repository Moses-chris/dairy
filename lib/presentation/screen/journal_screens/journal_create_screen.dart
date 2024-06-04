import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/domain/models/journal/journal.dart';
import 'package:myapp/domain/repository/journal_repo.dart';
import 'package:myapp/presentation/cubits/cubit_state/cubit_state.dart';
import 'package:myapp/presentation/cubits/journal_create_cubit.dart';
import 'package:myapp/presentation/injector/injector.dart';
import 'package:myapp/presentation/routes/routes.dart';
import 'package:myapp/presentation/screen/date_picker_screen.dart';
import 'package:myapp/presentation/screen/mood_picker_screen.dart';
import 'package:myapp/presentation/shared/app_bar.dart';
import 'package:myapp/presentation/shared/form_models/jounral_form_model.dart';
import 'package:myapp/presentation/shared/form_validator.dart';
import 'package:myapp/presentation/shared/text_field.dart';
import 'package:myapp/presentation/theme/styling/theme_color_style.dart';
import 'package:myapp/presentation/utils/extension.dart';
import 'package:myapp/presentation/utils/padding_style.dart';
import 'package:myapp/presentation/widgets/floating_action_button.dart';

class JournalCreateScreen extends StatefulWidget
    implements Screen<JournalCreateScreenRoute> {
  @override
  final JournalCreateScreenRoute arg;
  const JournalCreateScreen({super.key, required this.arg});

  @override
  State<JournalCreateScreen> createState() => _JournalCreateScreenState();
}

class _JournalCreateScreenState extends State<JournalCreateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JournalCreateCubit>(
      create: (context) => JournalCreateCubit(
        journalRepo: Injector.resolve<JournalRepo>(),
        formKey: _formKey,
      ),
      child: BlocBuilder<JournalCreateCubit, CubitState<Journal>>(
        builder: (context, state) {
          // final addJournal = context.read<JournalCreateCubit>().addJournal();
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PrimaryAppBar(
              leadingOnTap: () => context.pop(),
              centerTitle: 'New Thought',
            ),
            body: SafeArea(
              minimum: const EdgeInsets.symmetric(
                  horizontal: CustomPadding.mediumPadding),
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  initialValue: JournalFormModel.initialValue(widget.arg.day),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
                      const AddNewDetails(),
                      const SizedBox(height: 30),
                      CustomDatePickerFormField(
                        name: JournalFormModel.createdAtKey,
                      ),
                      // FormBuilderDateTimePicker(name: name),
                      const SizedBox(height: 30),
                      MoodPickerFormField(
                        name: JournalFormModel.moodKey,
                        validator: FormValidator.required(),
                      ),
                      const SizedBox(height: 30),
                      const CustomTextFormField(
                        fieldKey: JournalFormModel.titleKey,
                        heading: 'Title',
                        label: 'Enter Mood Title',
                      ),
                      const SizedBox(height: 30),
                      const CustomTextFormField(
                        fieldKey: JournalFormModel.memoKey,
                        heading: 'Note',
                        label: 'Write Note',
                        isMultiline: true,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: SecondaryFloatingActionButton(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  context
                      .read<JournalCreateCubit>()
                      .addJournal()
                      .then((value) => context.shouldPop());
                }
              },
              child: const Icon(Icons.check),
            ),
          );
        },
      ),
    );
  }
}

class AddNewDetails extends StatelessWidget {
  const AddNewDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    final ThemeColorStyle themeColorStyle = context.themeColorStyle;
    final double deviceHeight = context.deviceHeight;
    final double deviceWidth = context.deviceWidth;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: deviceWidth * 0.02),
        const Image(image: AssetImage('assets/icons/book.png'), height: 36),
        SizedBox(width: deviceWidth * 0.03),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Details',
              style: textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w700,
                color: themeColorStyle.secondaryColor,
              ),
            ),
            SizedBox(height: deviceHeight * 0.004),
            Text(
              'Write your today’s thought details below',
              style:
                  textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}
