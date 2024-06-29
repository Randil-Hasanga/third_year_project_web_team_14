import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
        const SizedBox(
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
        const SizedBox(
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
        const Divider(),
      ],
    );
  }

  Widget deletedProviderTableRow(
      String email,
      String companyName,
      String repName,
      String contactNo,
      String deletedBy,
      String deletedDate,
      double fontSize,
      Color color,
      Color backgroundColor,
      String? action,
      {VoidCallback? function}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double totalWidth = constraints.maxWidth;
        double columnWidth1 = totalWidth * 0.15; // 15% of total width
        double columnWidth2 = totalWidth * 0.20; // 25% of total width
        double columnWidth3 = totalWidth * 0.15; // 15% of total width
        double columnWidth4 = totalWidth * 0.1; // 15% of total width
        double columnWidth5 = totalWidth * 0.15; // 15% of total width
        double columnWidth6 = totalWidth * 0.15; // 15% of total width

        return Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.symmetric(
              inside: const BorderSide(
                  color: Colors.black, style: BorderStyle.solid)),
          columnWidths: {
            0: FixedColumnWidth(columnWidth1), // Adjust as necessary
            1: FixedColumnWidth(columnWidth2), // Adjust as necessary
            2: FixedColumnWidth(columnWidth3), // Adjust as necessary
            3: FixedColumnWidth(columnWidth4), // Adjust as necessary
            4: FixedColumnWidth(columnWidth5), // Adjust as necessary
            5: FixedColumnWidth(columnWidth6), // Adjust as necessary
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2.0),
                    child: Center(
                      child: Text(
                        companyName,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2.0),
                    child: Center(
                      child: Text(
                        email,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2.0),
                    child: Center(
                      child: Text(
                        repName,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2.0),
                    child: Center(
                      child: Text(
                        contactNo,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2.0),
                    child: Center(
                      child: Text(
                        deletedBy,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2.0),
                    child: Center(
                      child: Text(
                        deletedDate,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2.0),
                    child: Center(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: function,
                            icon: const Icon(Icons.restore_page),
                          ),
                          InkWell(
                            child: GestureDetector(
                              onTap: function,
                              child: Text(
                                action!,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget deletedSeekerTableRow(
      String userName,
      String email,
      String deletedBy,
      String deletedDate,
      double fontSize,
      Color color,
      Color backgroundColor,
      String? action,
      {VoidCallback? function}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double totalWidth = constraints.maxWidth;
        double columnWidth1 = totalWidth * 0.15; // 15% of total width
        double columnWidth2 = totalWidth * 0.25; // 25% of total width
        double columnWidth3 = totalWidth * 0.20; // 15% of total width
        double columnWidth4 = totalWidth * 0.25; // 15% of total width
        double columnWidth5 = totalWidth * 0.15; // 15% of total width

        return Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.symmetric(
              inside: const BorderSide(
                  color: Colors.black, style: BorderStyle.solid)),
          columnWidths: {
            0: FixedColumnWidth(columnWidth1), // Adjust as necessary
            1: FixedColumnWidth(columnWidth2), // Adjust as necessary
            2: FixedColumnWidth(columnWidth3), // Adjust as necessary
            3: FixedColumnWidth(columnWidth4), // Adjust as necessary
            4: FixedColumnWidth(columnWidth5), // Adjust as necessary
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2.0),
                    child: Center(
                      child: Text(
                        userName,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2.0),
                    child: Center(
                      child: Text(
                        email,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2.0),
                    child: Center(
                      child: Text(
                        deletedBy,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2.0),
                    child: Center(
                      child: Text(
                        deletedDate,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2.0),
                    child: Center(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: function,
                            icon: const Icon(Icons.restore_page),
                          ),
                          InkWell(
                            child: GestureDetector(
                              onTap: function,
                              child: Text(
                                action!,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
