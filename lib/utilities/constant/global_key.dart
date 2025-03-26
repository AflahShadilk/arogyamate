 import 'package:flutter/material.dart';

final GlobalKey<FormState> docForm = GlobalKey<FormState>();
  const isLoggedIn='userLoggedIn';
  final GlobalKey<FormState> appoinmentForm = GlobalKey<FormState>();
  final GlobalKey<FormState> doctorDetail = GlobalKey<FormState>();//edit doctor
  final GlobalKey<FormState> patientDetail = GlobalKey<FormState>();//edit doctor

//-----------------------------------------------------------------------------------
  final GlobalKey<FormState> bottumSheetForm = GlobalKey<FormState>();
    final GlobalKey<FormState> bottumSheetSearch = GlobalKey<FormState>();
//---------------------------------------------------------------------------------------
  final GlobalKey<FormState> timeSearch = GlobalKey<FormState>();
  final GlobalKey<FormState> searchin = GlobalKey<FormState>();
  TextEditingController timeController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    