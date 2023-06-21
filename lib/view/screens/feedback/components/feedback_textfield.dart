import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackTextField extends StatelessWidget {
  const FeedbackTextField({
    Key? key,
    required this.onTextChange,
  }) : super(key: key);

  final void Function(String text) onTextChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        minLines: 1,
        maxLines: 30,
        onChanged: (String text) => onTextChange(text),
        initialValue: '',
        /*style: theme.inputDecorationTheme.labelStyle?.copyWith(
                fontSize: 14,
                color: theme.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),*/
        decoration: InputDecoration(
          //labelText: 'Your thoughts',
          labelStyle: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  color: Color.fromARGB(211, 141, 176, 253),
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(width: 2.0, color: Colors.indigo[100]!),
          ),
          contentPadding: const EdgeInsets.all(10.0),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            borderSide: BorderSide(
              width: 2.0,
              color: Color.fromARGB(212, 221, 232, 255),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            borderSide: BorderSide(
              width: 2.0,
              color: Color.fromARGB(212, 221, 232, 255),
            ),
          ),
        ),
      ),
    );
  }
}
