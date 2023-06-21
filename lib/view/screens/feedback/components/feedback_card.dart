import 'package:flutter/material.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({super.key, required this.header, required this.body});
  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(14.0),
        width: double.infinity,
        child: Column(
          children: [
            header,
            Divider(color: Colors.blueGrey[200]),
            const SizedBox(
              height: 8.0,
            ),
            body,
          ],
        ),
      ),
    );
  }
}
