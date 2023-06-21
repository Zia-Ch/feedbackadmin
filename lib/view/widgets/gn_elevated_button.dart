import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class GenericElevatedButton extends ConsumerWidget {
  const GenericElevatedButton({
    super.key,
    required this.isLoading,
    required this.size,
    required this.btnText,
    required this.voidCallBack,
  });
  final String btnText;
  final bool isLoading;
  final Size size;
  final void Function()? voidCallBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12), // ! Hard coded value for border radius
          ),
        ),
        elevation: 1.0, // !  Hard coded value for elevation
        minimumSize:
            const Size(double.infinity, 62), // ! hard coded value for height
        foregroundColor: Colors.white, // ! Hard coded value for color
        backgroundColor: Colors.blue, // ! Hard coded value for color
        textStyle: GoogleFonts.nunitoSans(), // ! Hard coded value for fonts
      ),
      onPressed: voidCallBack,
      child: isLoading
          ? const Center(
              child: SizedBox(
              // ! Hard coded value for sized box
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2.0, // ! Hard coded value for stroke width
              ),
            ))
          : Text(
              btnText,
            ),
    );
  }
}
