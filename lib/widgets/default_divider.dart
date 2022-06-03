import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class DefaultDivider extends StatelessWidget {
  const DefaultDivider({Key? key, this.text}) : super(key: key);

  final String? text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 150,
          child: Divider(
            height: 5,
            thickness: 2,
            indent: 2,
            //endIndent:25,
            color: Colors.white70,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text!,
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        const SizedBox(
          width: 150,
          child: Divider(
            height: 5,
            thickness: 2,
            //indent: 25,
            endIndent:2,
            color: Colors.white70,
          ),
        ),

      ],
    );
  }
}
