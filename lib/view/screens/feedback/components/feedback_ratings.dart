import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackRatings extends StatelessWidget {
  const FeedbackRatings({
    Key? key,
    required this.onSubmitRating,
  }) : super(key: key);

  final void Function(double value) onSubmitRating;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.grey[50]!,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        border: Border.all(
            width: 2.0,
            color: theme.brightness == Brightness.light
                ? const Color.fromARGB(212, 221, 232, 255)
                : Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: RatingBar.builder(
              wrapAlignment: WrapAlignment.center,
              itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              initialRating: 0.0, //widget.properties!.ratingValue!,
              itemCount: 5,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return const Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return const Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return const Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return const Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                  default:
                    return Container();
                }
              },
              onRatingUpdate: (double value) => onSubmitRating(value),
            ),
          ),
        ],
      ),
    );
  }
}
