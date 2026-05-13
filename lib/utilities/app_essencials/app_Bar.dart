import 'package:flutter/material.dart';

AppBar appBar(
  BuildContext context,
  String title, {
  bool showDeleteButton = true,
  Function()? deleteFunction, 
}) {
  return AppBar(
    elevation: 0,
    backgroundColor: Theme.of(context).colorScheme.primary,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios, size: 24, color: Theme.of(context).colorScheme.onPrimary),
      onPressed: () => Navigator.pop(context),
    ),
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
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
                content: Text(
                  "Are you sure you want to delete this item?",
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel", style: TextStyle(color: Theme.of(context).hintColor)),
                  ),
                  TextButton(
                    onPressed: () async {
                      await deleteFunction(); 
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    child: Text("Delete", style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ),
                ],
              ),
            );
          },
          icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.onError, size: 28),
        ),
    ],
  );
}
