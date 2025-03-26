import 'package:flutter/material.dart';

class Constants {
 static String fullday="Fullday";
 static String halfday="Halfday";
 static String leave="Leave";
 static String nightshift="Night";
static List<String> fulldatTime=['10.00am','6.00pm'];  
static List<String> halfdayTime=["12.00am","6.00pm"];  
static List<String> nightshiftTime=["5.00pm","6.00Am"];  
}

bool isPhone(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}