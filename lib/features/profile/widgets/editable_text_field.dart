import "package:flutter/material.dart";

class EditableTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isEditing;
  final ValueChanged<bool> onEditToggle;
  final String label;
  final Icon prefixIcon;

  const EditableTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isEditing,
    required this.onEditToggle,
    required this.label,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: prefixIcon,
        suffixIcon: IconButton(
          onPressed: () => onEditToggle(!isEditing),
          icon: Icon(
            isEditing ? Icons.check : Icons.edit,
            color: Colors.white,
          ),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      readOnly: !isEditing,
      validator: (value) {
        if(value == null || value.trim().isEmpty) {
          return "$label is required!";
        }
        return null;
      },
    );
  }
}