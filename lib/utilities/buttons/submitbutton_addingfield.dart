import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

SizedBox submit(BuildContext context, bool isPhone, void Function()? onPressed) {
    return SizedBox(
                  width: isPhone ? s.width * 0.6 : s.width * 0.5,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      // ignore: deprecated_member_use
                      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                    label: Text(
                      'Submit',
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: isPhone ? 16 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: isPhone ? 22 : 26,
                    ),
                  ),
                );
  }