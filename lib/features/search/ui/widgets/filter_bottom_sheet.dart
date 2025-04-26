import 'package:flutter/material.dart';

class FilterBottomSheet extends StatelessWidget {
  final List<String> modes;
  final List<String> categories;
  final List<String> governorates;
  final String? selectedMode;
  final int selectedAge;
  final String? selectedCategory;
  final String? selectedGovernorate;
  final Function(String?) onModeChanged;
  final Function(int) onAgeChanged;
  final Function(String?) onCategoryChanged;
  final Function(String?) onGovernorateChanged;
  final VoidCallback onClearFilters;
  final VoidCallback onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.modes,
    required this.categories,
    required this.governorates,
    required this.selectedMode,
    required this.selectedAge,
    required this.selectedCategory,
    required this.selectedGovernorate,
    required this.onModeChanged,
    required this.onAgeChanged,
    required this.onCategoryChanged,
    required this.onGovernorateChanged,
    required this.onClearFilters,
    required this.onApplyFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StatefulBuilder(
        builder: (context, setSheetState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Filter by", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF02457A))),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Availability"),
                  value: selectedMode,
                  items: modes.map((mode) => DropdownMenuItem(value: mode, child: Text(mode))).toList(),
                  onChanged: (value) => setSheetState(() => onModeChanged(value)),
                ),
                SizedBox(height: 10),
                Text("Age"),
                Slider(
                  value: selectedAge.toDouble(),
                  min: 1,
                  max: 15,
                  divisions: 14,
                  label: "$selectedAge",
                  onChanged: (value) => setSheetState(() => onAgeChanged(value.toInt())),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Category"),
                  value: selectedCategory,
                  items: categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                  onChanged: (value) => setSheetState(() => onCategoryChanged(value)),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Governorate"),
                  value: selectedGovernorate,
                  items: governorates.map((gov) => DropdownMenuItem(value: gov, child: Text(gov))).toList(),
                  onChanged: (value) => setSheetState(() => onGovernorateChanged(value)),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        onClearFilters();
                        Navigator.pop(context);
                      },
                      child: Text("Clear", style: TextStyle(color: Colors.red)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onApplyFilters();
                        Navigator.pop(context);
                      },
                      child: Text("Apply", style: TextStyle(color: Color(0xFF02457A))),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
