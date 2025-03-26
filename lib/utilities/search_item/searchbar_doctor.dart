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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
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
              borderSide: BorderSide(color: Colors.grey[200]!, width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1A5CFF), width: 2),
            ),
            prefixIcon: IconButton(
              icon: Icon(Icons.search, color: Colors.grey[600]),
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
                  icon: const Icon(Icons.filter_list, color: Colors.blue),
                  onPressed: widget.onFilterPressed,
                ),
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500]),
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
