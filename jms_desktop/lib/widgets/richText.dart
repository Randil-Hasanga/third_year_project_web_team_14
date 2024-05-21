import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class RichTextWidget {
  RichTextWidget();

  Widget simpleText(
      String text, double? fontSize, Color color, FontWeight? fontweight) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: color,
          fontWeight: fontweight,
        ),
      ),
    );
  }

  Widget simpleTextWithIconLeft(IconData icon, String text, double? fontSize,
      Color color, FontWeight? fontweight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
        ),
        SizedBox(
          width: 10,
        ),
        RichText(
          softWrap: true,
          text: TextSpan(
            text: text,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: color,
              fontWeight: fontweight,
            ),
          ),
        ),
      ],
    );
  }

  Widget simpleTextWithIconRight(IconData icon, String text, double? fontSize,
      Color color, FontWeight? fontweight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          softWrap: true,
          text: TextSpan(
            text: text,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: color,
              fontWeight: fontweight,
            ),
          ),
        ),
        SizedBox(
          width: 6,
        ),
        Icon(icon),
      ],
    );
  }

  Widget KeyValuePairrichText(
      String keyText, String valueText, double fontSize) {
    return Column(
      children: [
        Table(
          columnWidths: const {
            0: FixedColumnWidth(200),
          },
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: RichText(
                      text: TextSpan(
                        text: keyText,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: RichText(
                      text: TextSpan(
                        text: valueText,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
