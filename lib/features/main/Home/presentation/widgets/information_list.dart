import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/information_item.dart';

class InformationList extends StatelessWidget {
  const InformationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: const InformationItem(
            title: 'Daily Streak',
            icon: Assets.svgsStreak,
            theinfo: '3 days',
          ),
        ),
        SizedBox(width: 12.w),

        Expanded(
          child: const InformationItem(
            title: 'Tasks Done',
            icon: Assets.svgsDone,
            theinfo: '5/12',
          ),
        ),
      ],
    );
  }
}
