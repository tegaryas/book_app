import 'package:flutter/material.dart';

class MainSearchBar extends StatelessWidget {
  const MainSearchBar({
    super.key,
    this.margin = const EdgeInsets.symmetric(horizontal: 28),
    this.enabled = false,
    this.onChange,
    this.controller,
  });

  final EdgeInsets margin;
  final bool enabled;
  final void Function(String query)? onChange;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      margin: margin,
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: Theme.of(context).shadowColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              enabled: enabled,
              controller: controller,
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'Search Book, Authors etc',
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(
                  fontSize: 14,
                  height: 2,
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                onChange?.call(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
