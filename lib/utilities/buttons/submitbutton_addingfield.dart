 import 'package:arogyamate/utilities/colors/addpages_color.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

SizedBox submit(bool isPhone, void Function()? onPressed) {
    return SizedBox(
                  width: isPhone ? s.width * 0.6 : s.width * 0.5,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: successColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      // ignore: deprecated_member_use
                      shadowColor: successColor.withOpacity(0.4),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                    label: Text(
                      'Submit',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: isPhone ? 16 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: isPhone ? 22 : 26,
                    ),
                  ),
                );
  }