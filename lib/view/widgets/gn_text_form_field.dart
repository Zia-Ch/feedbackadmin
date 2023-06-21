import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenericTextField extends StatelessWidget {
  const GenericTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.enaabled,
    this.keyboardType,
    /*this.autovalidateMode,
    this.validator,
    this.autocorrect,
    this.obsecureText,
    this.textInputAction,
    this.keyboardType,
    this.onEditingComplete,
    this.inputFormatters,*/
  });
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? enaabled;
  /*final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final bool? autocorrect;
  final bool? obsecureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final void Function()? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;*/

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.blue, // ! Hard coded value for cursor color
      style: GoogleFonts.nunitoSans(
          // color: Colors.black,
          ), // ! Hard coded value for font
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.nunitoSans(
            //color: Colors.grey,
            ), // ! Hard coded value for font
        filled: true,
        fillColor: Colors.white, // ! Hard coded value for color
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ), // ! Hard coded value for border radius
            borderSide: BorderSide.none),
      ),
    );
  }
}
