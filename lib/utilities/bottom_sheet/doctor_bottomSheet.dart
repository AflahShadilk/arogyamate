// // ignore: file_names
// import 'package:arogyamate/Data_Base/functions/db_doctorfuctions.dart';
// import 'package:arogyamate/Data_Base/functions/db_functions.dart';
// import 'package:arogyamate/Data_Base/models/doc_model.dart';
// import 'package:arogyamate/UTILITIES/global_key.dart';
// import 'package:arogyamate/UTILITIES/media_query.dart';
// import 'package:flutter/material.dart';

// void showBottomSheet2(
//     BuildContext context, bool isphone, TextEditingController control) {
//   bool isPhone = s.width < 600;
//   showModalBottomSheet(
//     isScrollControlled: true,
//     context: context,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
//       return Padding(
//         padding:
//             EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: SizedBox(
//           height: isPhone ? s.height * 0.7 : s.height * 0.7,
//           child: Column(
//             children: [
//               SizedBox(height: 20),
//               Wrap(
//                 runSpacing: 30,
//                 spacing: 10,
//                 children: [
//                   Column(
//                     children: [
//                       BottumSheetColumn(
//                         hint: 'Add new',
//                         icon: Icons.add,
//                         colorr: Colors.blueAccent,
//                       ),
//                       SizedBox(height: 10),
//                       BottumSheetColumn2(
//                         hint: 'Search',
//                         icon: Icons.search_outlined,
//                         colorr: Colors.greenAccent,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Expanded(
//                 child: Container(
//                   width: isPhone ? s.width * 0.95 : s.width * 0.95,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: const Color.fromARGB(96, 242, 248, 174),
//                   ),
//                   child: ValueListenableBuilder(
//                     valueListenable: doctorNotifier,
//                     builder: (BuildContext context,
//                         List<DoctorModel> doctorsList, Widget? child) {
//                       return doctorNotifier.value.isEmpty
//                           ? Center(
//                               child: Text(
//                                 'Not Depatment Found!',
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             )
//                           : ListView.separated(
//                               physics: BouncingScrollPhysics(),
//                               itemBuilder: (context, int index) {
//                                 final data = doctorsList[index];

//                                 return GestureDetector(
//                                   onTap: () {
//                                     control.text = data.name!;
//                                     Navigator.pop(context);
//                                   },
//                                   child: ListTile(
//                                     title: Text(data.name!),
                                    
//                                   ),
//                                 );
//                               },
//                               separatorBuilder: (context, index) =>
//                                   const Divider(),
//                               itemCount: doctorsList.length,
//                             );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

// //---------------------------------------------------------------------------------------------column inside the bottomsheet
// // ignore: must_be_immutable
// class BottumSheetColumn extends StatefulWidget {
//   String hint;
//   IconData icon;
//   Color colorr;
//   BottumSheetColumn(
//       {super.key,
//       required this.hint,
//       required this.icon,
//       required this.colorr});

//   @override
//   State<BottumSheetColumn> createState() => _BottumSheetColumnState();
// }

// class _BottumSheetColumnState extends State<BottumSheetColumn> {
  
//   final TextEditingController bottomAddKeys = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     bool isPhone = s.width < 600;
//     return IntrinsicHeight(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             child: Form(
//               // key: bottumSheetForm,
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(
//                     isPhone ? 20 : 30, 0, isPhone ? 20 : 30, 0),
//                 child: TextFormField(
//                   controller: bottomAddKey,
//                   decoration: InputDecoration(
//                     errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     fillColor: Colors.blueGrey[100],
//                     filled: true,
//                     contentPadding: EdgeInsets.all(10),
//                     hintText: widget.hint,
//                     hintStyle: TextStyle(color: Colors.black45),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Don't be Empty";
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding:
//                 EdgeInsets.fromLTRB(0, 0, isPhone ? 20 : 30, isPhone ? 20 : 30),
//             child: SizedBox(
//               height: isPhone ? s.height * 0.06 : s.height * 0.05,
//               width: isPhone ? s.width * 0.15 : s.width * 0.04,
//               child: ElevatedButton(
//                 onPressed: () {
//                   onPressed();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: widget.colorr,
//                   padding: EdgeInsets.zero,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Icon(widget.icon),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> onPressed() async {
//     if (bottumSheetForm.currentState!.validate()) {
//       final name = bottomAddKey.text.trim();
//       if (name.isNotEmpty) {
//         final department = DepartmentModel(department: name);
//         addDepartment(department);

//         bottomAddKey.clear();
//         setState(() {});
//       }
//     }
//   }
// }

// //---------------------------------------------------------------------------------------------------------Search reuse
// // ignore: must_be_immutable
// class BottumSheetColumn2 extends StatefulWidget {
//   String hint;
//   IconData icon;
//   Color colorr;
//   BottumSheetColumn2(
//       {super.key,
//       required this.hint,
//       required this.icon,
//       required this.colorr});

//   @override
//   State<BottumSheetColumn2> createState() => _BottumSheetColumn2State();
// }

// class _BottumSheetColumn2State extends State<BottumSheetColumn2> {

//   final TextEditingController bottomSearch = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     bool isPhone = s.width < 600;
//     return IntrinsicHeight(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             child: Form(
//               key: bottumSheetSearch,
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(
//                     isPhone ? 20 : 30, 0, isPhone ? 20 : 30, 0),
//                 child: TextFormField(
//                   onChanged: (value) {
//                     searchDepartment(value);
//                   },
//                   controller: bottomSearch,
//                   decoration: InputDecoration(
//                     errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     fillColor: Colors.blueGrey[100],
//                     filled: true,
//                     contentPadding: EdgeInsets.all(10),
//                     hintText: widget.hint,
//                     hintStyle: TextStyle(color: Colors.black45),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Don't be Empty";
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding:
//                 EdgeInsets.fromLTRB(0, 0, isPhone ? 20 : 30, isPhone ? 20 : 30),
//             child: SizedBox(
//               height: isPhone ? s.height * 0.06 : s.height * 0.05,
//               width: isPhone ? s.width * 0.15 : s.width * 0.04,
//               child: ElevatedButton(
//                 onPressed: () {
//                   searchDepartment(bottomSearch.text);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: widget.colorr,
//                   padding: EdgeInsets.zero,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Icon(widget.icon),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }