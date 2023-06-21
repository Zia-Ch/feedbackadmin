import 'package:flutter/material.dart';

class FeedbackCardHeader extends StatelessWidget {
  const FeedbackCardHeader({
    Key? key,
    required this.question,
    required this.qnumber,
  }) : super(key: key);
  final String question;
  final int qnumber;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Q$qnumber: ",
          style: theme.textTheme.titleMedium
              ?.copyWith(color: Colors.red[400], fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: Text(
            question,
            style: theme.textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
