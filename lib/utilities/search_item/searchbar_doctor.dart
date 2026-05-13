import 'package:flutter/material.dart';

class CommonSearch extends StatefulWidget {
  final bool isPhone;
  final String hint;
  final TextEditingController controller;
  final Function(String)? onSearch;
  final VoidCallback onFilterPressed;
  final VoidCallback onClearPressed;

  const CommonSearch({
    super.key,
    required this.isPhone,
    required this.hint,
    required this.controller,
    this.onSearch,
    required this.onFilterPressed,
    required this.onClearPressed,
  });

  @override
  State<CommonSearch> createState() => _CommonSearchState();
}

class _CommonSearchState extends State<CommonSearch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.isPhone ? 0 : 20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).cardColor,
            hintText: widget.hint,
            hintStyle: TextStyle(color: Theme.of(context).hintColor),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
            prefixIcon: IconButton(
              icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                if (widget.onSearch != null) {
                  widget.onSearch!(widget.controller.text);
                }
              },
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.filter_list, color: Theme.of(context).colorScheme.secondary),
                  onPressed: widget.onFilterPressed,
                ),
                IconButton(
                  icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onClearPressed();
                    if (widget.onSearch != null) {
                      widget.onSearch!(""); 
                    }
                  },
                ),
              ],
            ),
          ),
          onChanged: (value) {
            if (widget.onSearch != null) {
              widget.onSearch!(value);
            }
          },
        ),
      ),
    );
  }
}
