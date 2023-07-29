import 'package:flutter/material.dart';

class BulletListButton extends StatelessWidget {
  final TextEditingController controller;

  const BulletListButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggleBulletList,
      icon: Icon(Icons.format_list_bulleted),
    );
  }

  void _toggleBulletList() {
    final text = controller.text;
    final selection = controller.selection;

    final start = selection.start;
    final end = selection.end;

    final before = text.substring(0, start);
    final after = text.substring(end);

    final middle = text.substring(start, end);

    final newText = '$before\n• $middle$after';

    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: start + 3),
    );
  }
}
