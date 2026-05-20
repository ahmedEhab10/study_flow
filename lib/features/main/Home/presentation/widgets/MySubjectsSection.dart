import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:study_flow/Core/Routes_Manager/routes.dart';
import 'package:study_flow/features/main/Home/presentation/cubit/subjects_cubit.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/subject_item.dart';

class MySubjectsSection extends StatelessWidget {
  const MySubjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final visibleSubjects = context.watch<SubjectsCubit>().state.subjects.take(3).toList();

    return SliverGrid(
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 2,

        mainAxisSpacing: 14,
        crossAxisSpacing: 14,

        repeatPattern: QuiltedGridRepeatPattern.same,

        pattern: const [
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 2),
        ],
      ),

      delegate: SliverChildBuilderDelegate((context, index) {
        final subject = visibleSubjects[index];

        return SubjectItem(
          subject: subject,
          isLarge: index == 2,
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.subject_screen,
              arguments: subject,
            );
          },
        );
      }, childCount: visibleSubjects.length),
    );
  }
}
