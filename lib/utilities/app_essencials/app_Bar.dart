import 'package:flutter/material.dart';

AppBar appBar(
  BuildContext context,
  String title, {
  bool showDeleteButton = true,
  Function()? deleteFunction, 
}) {
  return AppBar(
    elevation: 0,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios, size: 24, color: Colors.white),
      onPressed: () => Navigator.pop(context),
    ),
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    ),
    actions: [
      if (showDeleteButton && deleteFunction != null) 
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: const Text(
                  "Confirm Deletion",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: const Text(
                  "Are you sure you want to delete this item?",
                  style: TextStyle(color: Colors.grey),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () async {
                      await deleteFunction(); 
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          icon: Icon(Icons.delete_outline, color: Colors.red[300], size: 28),
        ),
    ],
  );
}
