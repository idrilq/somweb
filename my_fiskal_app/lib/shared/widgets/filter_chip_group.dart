import 'package:flutter/material.dart';

class FilterChipGroup extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final void Function(String?) onSelected;

  const FilterChipGroup({
    required this.options,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: options.map((option) {
        return ChoiceChip(
          label: Text(option),
          selected: selected == option,
          onSelected: (selected) => onSelected(selected ? option : null),
        );
      }).toList(),
    );
  }
}
