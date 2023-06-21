import 'package:feedbackadmin/helper/extentions/widget_padding.dart';
import 'package:feedbackadmin/models/feedback/feedback_home_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeDataCard extends ConsumerWidget {
  const HomeDataCard({
    super.key,
    required this.data,
    required this.onTap,
  });
  final FeedbackHomeDataModel data;
  final void Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.red[200]!, width: 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                data.subjectModel.subjectName,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                data.subjectModel.subjectCode,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Teacher Name',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    data.userTeacherFeedbackMxN.id,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ]).addPadding(14),
      ),
    );
  }
}
