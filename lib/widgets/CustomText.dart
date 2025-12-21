import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class Txt extends StatelessWidget {
  final String txt;
  final double? fntSize;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxline;


  const Txt({super.key, required this.txt,  this.fntSize,  this.fontWeight,  this.color,this.maxline});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(fontSize: fntSize, fontWeight: fontWeight,color: color),
    );
  }
}
