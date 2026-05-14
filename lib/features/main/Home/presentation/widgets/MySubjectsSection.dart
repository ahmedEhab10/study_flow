import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:study_flow/Core/const/subject_list.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/subject_item.dart';

class MySubjectsSection extends StatelessWidget {
  const MySubjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final visibleSubjects = subjects.take(3).toList();

    return GridView.custom(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

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

      childrenDelegate: SliverChildBuilderDelegate(
        childCount: visibleSubjects.length,
        (context, index) {
          final subject = visibleSubjects[index];

          return SubjectItem(
            subject: subject,
            isLarge: index == 2,
            onTap: () {},
          );
        },
      ),
    );
  }
}
