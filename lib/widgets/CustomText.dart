import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class Txt extends StatelessWidget {
  final String txt;
  final double? fntSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;




  const Txt({super.key, required this.txt,  this.fntSize,  this.fontWeight,  this.color, this.textAlign, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: GoogleFonts.poppins(fontSize: fntSize, fontWeight: fontWeight,color: color),
    );
  }
}
